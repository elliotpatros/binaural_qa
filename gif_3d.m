nHrtfs = 187;

load './HRTFs/IRC_1002/COMPENSATED/MAT/HRIR/IRC_1002_C_HRIR.mat'

elevs = zeros(nHrtfs, 1);
azims = zeros(nHrtfs, 1);
mags = zeros(nHrtfs, 2);

for n = 1:nHrtfs
    % get elevation and azimuth for the nth hrtf
    elev = l_eq_hrir_S.elev_v(n);
    azim = l_eq_hrir_S.azim_v(n);
    
    % they're in degrees, so convert them to radians
    elev = deg2rad(elev);
    azim = deg2rad(azim);
    
    % get loudest absolute value of hrir
    lhrir = l_eq_hrir_S.content_m(n,:);
    rhrir = r_eq_hrir_S.content_m(n,:);
    lmag = max(abs(lhrir));
    rmag = max(abs(rhrir));
    
    % plot it
    [x, y, z] = sph2cart(ones(3,1)*azim, ones(3,1)*elev, [lmag; rmag; 1]);
    plot3(x(1), y(1), z(1), 'r*', x(2), y(2), z(2), 'b*');
    hold on;
    
    % save it
    elevs(n) = elev;
    azims(n) = azim;
    mags(n, 1) = lmag;
    mags(n, 2) = rmag;
end

axis vis3d;
grid on;
hold off;

filename = 'test.gif';
nSteps = 300;
viewangles = [linspace(-15, 345, nSteps)', linspace(30, 30, nSteps)'];
for n = 1:nSteps
    view(viewangles(n,:));
    frame = getframe(1);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    if n == 1
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 1/60);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 1/60);
    end
end
