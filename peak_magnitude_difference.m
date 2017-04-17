clear all;

%% get all hrtfs
directory = dir('./HRTFs/');
subs = directory([directory.isdir]);
subs(ismember({subs.name}, {'.','..'})) = [];
clear folder

%% open text file to write results
% get ready to store loudest and quietest hrtfs
loudest  = 0;      % subject s' loudest peak magnitude
softest  = 100;    % subject s' softest peak magnitude
    
%% measure each subject
for s = 1:length(subs)
    % load nth .mat
    matfile = [subs(s).folder, '/', subs(s).name, '/', ...
               'COMPENSATED/MAT/HRIR', '/', subs(s).name, '_C_HRIR.mat'];
    load(matfile)

    % measure each hrtf
    nHrtfs = length(l_eq_hrir_S.elev_v);
    for n = 1:nHrtfs
        % get elevation and azimuth for the nth hrtf
        elev = l_eq_hrir_S.elev_v(n);
        azim = l_eq_hrir_S.azim_v(n);

        % get loudest absolute value of hrir
        lhrir = l_eq_hrir_S.content_m(n,:);
        rhrir = r_eq_hrir_S.content_m(n,:);
        lmag = max(abs(lhrir));
        rmag = max(abs(rhrir));
        mmag = max(lmag, rmag);
        smag = min(lmag, rmag);
        
        
        % check if this is the loudest
        if mmag > loudest
            loudest = lmag;
        end

        % check if this is the softest
        if smag < softest
            softest = smag;
        end
    end
end

disp(num2str(mag2db([loudest softest])))
