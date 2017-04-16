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
	lloudest  = 0;      % subject s' loudest peak magnitude (left)
    lloudesti = 0;      % index of subject s' loudest peak magnitude (left)
	lsoftest  = 100;    % subject s' softest peak magnitude (left)
    lsoftesti = 0;      % index of subject s' softest peak magnitude (left)
	rloudest  = 0;      % subject s' loudest peak magnitude (right)
    rloudesti = 0;      % index of subject s' loudest peak magnitude (right)
	rsoftest  = 100;    % subject s' softest peak magnitude (right)
    rsoftesti = 0;      % index of subject s' softest peak magnitude (right)
    mloudest  = 0;      % subject s' loudest peak magnitude (sum)
    mloudesti = 0;      % index of subject s' loudest peak magnitude (sum)
    msoftest  = 100;    % subject s' loudest peak magnitude (sum)
    msoftesti = 0;      % index of subject s' loudest peak magnitude (sum)

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
        mmag = lmag + rmag;
        
        
		% check if this is the loudest
		if lmag > lloudest
			lloudest = lmag;
            lloudesti = n;
        end
		if rmag > rloudest
			rloudest = rmag;
            rloudesti = n;
        end
        if mmag > mloudest
			mloudest = mmag;
            mloudesti = n;
        end

		% check if this is the softest
		if lmag < lsoftest
			lsoftest = lmag;
            lsoftesti = n;
        end
		if rmag < rsoftest
			rsoftest = rmag;
            rsoftesti = n;
        end
        if mmag < msoftest
			msoftest = mmag;
            msoftesti = n;
        end

    end

	% get the max difference between respective hrtfs
	ldiff = mag2db(lloudest) - mag2db(lsoftest);
	rdiff = mag2db(rloudest) - mag2db(rsoftest);
    mdiff = mag2db(mloudest) - mag2db(msoftest);

	% write results to text file
	fprintf(fileID, 'subject %s\n\tLHS: %fdB.\n\tRHS: %fdB.\n\tmix: %fdB.\n\n', subs(s).name, ldiff, rdiff, mdiff);
end

fclose(fileID);
