clear all;

%% get all hrtfs
directory = dir('./HRTFs/');
subs = directory([directory.isdir]);
subs(ismember({subs.name}, {'.','..'})) = [];
clear folder

%% open text file to write results
fileID = fopen('magnitude_differences.txt', 'w');

%% measure each subject
for s = 1:length(subs)
    % load nth .mat
    matfile = [subs(s).folder, '/', subs(s).name, '/', ...
               'COMPENSATED/MAT/HRIR', '/', subs(s).name, '_C_HRIR.mat'];
    load(matfile)
    
	% get ready to store loudest and quietest hrtfs
	lloudest = 0;
    lloudesti = 0;
	lsoftest = 100;
    lsoftesti = 0;
	rloudest = 0;
    rloudesti = 0;
	rsoftest = 100;
    rsoftesti = 0;

    % get hrtfs
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
        
		% check if this is the loudest
		if lmag > lloudest
			lloudest = lmag;
            lloudesti = n;
        end
        
		if rmag > rloudest
			rloudest = rmag;
            rloudesti = n;
        end

		% check if this is the quietest
		if lmag < lsoftest
			lsoftest = lmag;
            lsoftesti = n;
        end
        
		if rmag < rsoftest
			rsoftest = rmag;
            rsoftesti = n;
		end

    end

	% get the max difference between respective hrtfs
	ldiff = mag2db(lloudest - lsoftest);
	rdiff = mag2db(rloudest - rsoftest);

	% report
	fprintf(fileID, 'subject %s\n\tLHS: %fdB.\n\tRHS: %fdB.\n\n', subs(s).name, ldiff, rdiff);
end

fclose(fileID);
