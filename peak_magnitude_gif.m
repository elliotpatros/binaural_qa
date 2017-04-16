clear all;

%% user parameters
HRTFs_folder = './HRTFs/';
show_dB = false;

%% get all hrtfs
directory = dir('./HRTFs/');
subjects = directory([directory.isdir]);
subjects(ismember({subjects.name}, {'.','..'})) = [];
nSubjects = length(subjects);
clear folder

%% plot peak magnitude by direction of arrival
for s = 1:nSubjects
    clc;
    disp(['plotting hrtf ', num2str(s), ' of ', num2str(nSubjects)]);
    % load nth .mat
    matfile = [subjects(s).folder, '/', subjects(s).name, '/', ...
               'COMPENSATED/MAT/HRIR', '/', subjects(s).name, '_C_HRIR.mat'];
    load(matfile)
    
    % get hrtfs
    nHrtfs = length(l_eq_hrir_S.elev_v);
    
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
        
        % convert to dB
        if (show_dB)
            lmag = 100 + mag2db(lmag);
            rmag = 100 + mag2db(rmag);
        end

        % plot it
        [x, y, z] = sph2cart(ones(3,1)*azim, ones(3,1)*elev, [lmag; rmag; 1]);
        plot3(x(1), y(1), z(1), 'r.', x(2), y(2), z(2), 'b.');
        hold on;
    end
end

% subplot(121);
axis vis3d;
grid on;
hold off;
ylabel('left/right');
xlabel('front/back');
zlabel('up/down');


filename = 'dB.gif';
nSteps = 600;
frameDur = 1/60;
viewangles = [linspace(-15, 345, nSteps)', linspace(30, 30, nSteps)'];
for n = 1:nSteps
    clc;
    disp(['recording frame ', num2str(n), ' of ', num2str(nSteps)]);
    x = 0:0.01:1;
    
    view(viewangles(n,:));
    frame = getframe(1);
    rgb = frame2im(frame);
    [ind, map] = rgb2ind(rgb, 256);
    if n == 1
        imwrite(ind, map, filename, 'gif', 'Loopcount', inf, 'DelayTime', frameDur);
    else
        imwrite(ind, map, filename, 'gif', 'WriteMode', 'append', 'DelayTime', frameDur);
    end
end
