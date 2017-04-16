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
    subplot(121);
    [x, y, z] = sph2cart(ones(3,1)*azim, ones(3,1)*elev, [lmag; rmag; 1]);
    plot3(x(1), y(1), z(1), 'r*', x(2), y(2), z(2), 'b*');
    hold on;
    %     plot3([x(3) 0], [y(3) 0], [z(3) 0], 'k');
    
    subplot(122);
    [x, y, z] = sph2cart(azim, elev, lmag + rmag);
    plot3(x, y, z, 'k*');
    hold on;

    
    % save it
    elevs(n) = elev;
    azims(n) = azim;
    mags(n, 1) = lmag;
    mags(n, 2) = rmag;
end

subplot(121);
axis vis3d;
grid on;
hold off;

subplot(122);
axis vis3d;
grid on;
hold off;



