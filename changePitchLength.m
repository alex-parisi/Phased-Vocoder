%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                 %%%%
%%%%    INPUT:                                       %%%%
%%%%                    sig - audioread(filename)    %%%%
%%%%                     Fs - Sample rate            %%%%
%%%%                   file - operations file        %%%%
%%%%                                                 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                 %%%%
%%%%    OUTPUT:                                      %%%%
%%%%                    sig - new audio signal       %%%%
%%%%                          that has been          %%%%
%%%%                          stretched and shifted  %%%%
%%%%                                                 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [sig,fs] = changePitchLength(sig_file, op_file)
    [sig,fs]=audioread(sig_file);
    % Read operations file %
    blocks = xlsread(op_file);
    numBlocks = size(blocks, 1);
    % Sort in descending order by StartTime %
    sortedBlocks = sortrows(blocks, -1);
    
    % Process each block %
    for (i = 1:numBlocks)
        % Split signal %
        startN = ceil(sortedBlocks(i, 1) * fs);
        endN = floor(sortedBlocks(i, 2) * fs);
        bef = [];
        aft = [];
        if (startN > 1)
            bef = sig(1:startN - 1);
        end
        if (endN < length(sig))
            aft = sig((endN - 1):end);
        end
        dur = sortedBlocks(i, 3);
        pitch = sortedBlocks(i, 4);
        segment = sig(startN:endN);
        % Process this block %
        segment = PhaseVocoder(segment, fs, dur, pitch);
        segment = audioread('finaloutput.wav');
        % Reassemble signal %
        sig = [bef ; segment ; aft];
    end
    
    % Clean up %
    delete 'output.wav' 'temp.wav' 'finaloutput.wav'
    
end