%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                 %%%%
%%%%    INPUT:                                       %%%%
%%%%             origSpeech - audioread(filename)    %%%%
%%%%                     Fs - Sample rate            %%%%
%%%%            newDuration - new length of          %%%%
%%%%                          speech                 %%%%
%%%%               newPitch - new pitch of speech    %%%%
%%%%                                                 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                 %%%%
%%%%    OUTPUT:                                      %%%%
%%%%             procSpeech - new audio signal       %%%%
%%%%                          that has been          %%%%
%%%%                          stretched and shifted  %%%%
%%%%                                                 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function procSpeech = PhaseVocoder(origSpeechSig, Fs, newDuration, newPitch)

    % Initialize %
    WindowLen = 256;
    
    % First process for pitch-shifting %
    
        % Determine original pitch %
        [maxValue, indexMax] = max(10 * log10(pwelch(origSpeechSig)));
        origFreq = indexMax * Fs / length(origSpeechSig);
        origPitch = 3233 * log10(1 + origFreq / 1000)

        % Determine pitch-shifting ratio %
        pitchRatio = newPitch / origPitch;

        % Set analysis and synthesis hop size
        SynthesisLen = 50;
        AnalysisLen = ceil(SynthesisLen / pitchRatio);
        Hopratio = pitchRatio;
        
        % Write temporary .wav file %
        audiowrite('temp.wav', origSpeechSig, Fs);

        % Create system objects used in processing %
        reader = dsp.AudioFileReader('temp.wav', 'SamplesPerFrame', AnalysisLen, 'OutputDataType', 'double');
        buff = dsp.Buffer(WindowLen, WindowLen - AnalysisLen); %Buffer
        win = dsp.Window('Hanning', 'Sampling', 'Periodic'); %Window
        dft = dsp.FFT; %FFT
        idft = dsp.IFFT('ConjugateSymmetricInput', true, 'Normalize', false); %IDFT
        player = audioDeviceWriter('SampleRate', Fs, 'SupportVariableSizeInput', true, 'BufferSize', 512); %Player
        logger = dsp.SignalSink; %Logger

        % Initialize Processing %
        yprevwin = zeros(WindowLen - SynthesisLen, 1);
        gain = 1 / (WindowLen * sum(hanning(WindowLen, 'periodic') .^ 2) / SynthesisLen);
        unwrapdata = 2 * pi * AnalysisLen * (0:WindowLen - 1)' / WindowLen;
        yangle = zeros(WindowLen, 1);
        firsttime = true;
        
        % Begin processing for pitch-shifting %
        while ~isDone(reader)
            y = reader();
            % Take windowed, buffered FFT of signal %
            yfft = dft(win(buff(y)));
            % Convert FFT data to magnitude and phase %
            ymag = abs(yfft);
            yprevangle = yangle;
            yangle = angle(yfft);
            % Synthesis-Phase Calculation %
            yunwrap = (yangle - yprevangle) - unwrapdata;
            yunwrap = yunwrap - round(yunwrap / (2 * pi)) * 2 * pi;
            yunwrap = (yunwrap + unwrapdata) * Hopratio;
            if (firsttime)
                ysangle = yangle;
                firsttime = false;
            else
                ysangle = ysangle + yunwrap;
            end
            % Convert magnitude and phase to complex numbers %
            ys = ymag .* complex(cos(ysangle), sin(ysangle));
            % Windowed IFFT %
            ywin  = win(idft(ys));
            % Overlap-add operation %
            olapadd  = [ywin(1:end-SynthesisLen,:) + yprevwin ; ywin(end-SynthesisLen+1:end,:)];
            yistfft  = olapadd(1:SynthesisLen, :);
            yprevwin = olapadd(SynthesisLen + 1:end, :);
            % Normalize %
            yistfft = yistfft * gain;
            % Log signal %
            logger(yistfft);
        end
        
        % Define pitch-shifted speech %
        pitchShiftedSpeech = logger.Buffer(200:end)';
        Fs = round(Fs * Hopratio);
        audiowrite('output.wav', pitchShiftedSpeech.', Fs);
        release(reader);
        
    % Second process for time-scaling %
    
        % Determine original duration %
        origDuration = length(pitchShiftedSpeech) / Fs;
        
        % Determine time-scaling ratio %
        timeRatio = newDuration / origDuration;
        
        % Set analysis and synthesis hop size
        SynthesisLen = 50;
        AnalysisLen = ceil(SynthesisLen / timeRatio);
        Hopratio = timeRatio;
        
        % Create system objects used in processing %
        reader = dsp.AudioFileReader('output.wav', 'SamplesPerFrame', AnalysisLen, 'OutputDataType', 'double');
        buff = dsp.Buffer(WindowLen, WindowLen - AnalysisLen); %Buffer
        win = dsp.Window('Hanning', 'Sampling', 'Periodic'); %Window
        dft = dsp.FFT; %FFT
        idft = dsp.IFFT('ConjugateSymmetricInput', true, 'Normalize', false); %IDFT
        player = audioDeviceWriter('SampleRate', Fs, 'SupportVariableSizeInput', true, 'BufferSize', 512); %Player
        logger = dsp.SignalSink; %Logger
        
        % Initialize Processing %
        yprevwin = zeros(WindowLen - SynthesisLen, 1);
        gain = 1 / (WindowLen * sum(hanning(WindowLen, 'periodic') .^ 2) / SynthesisLen);
        unwrapdata = 2 * pi * AnalysisLen * (0:WindowLen - 1)' / WindowLen;
        yangle = zeros(WindowLen, 1);
        firsttime = true;

        % Begin processing for time-scaling %
        while ~isDone(reader)
            y = reader();
            % Take windowed, buffered FFT of signal %
            yfft = dft(win(buff(y)));
            % Convert FFT data to magnitude and phase %
            ymag = abs(yfft);
            yprevangle = yangle;
            yangle = angle(yfft);
            % Synthesis-Phase Calculation %
            yunwrap = (yangle - yprevangle) - unwrapdata;
            yunwrap = yunwrap - round(yunwrap / (2 * pi)) * 2 * pi;
            yunwrap = (yunwrap + unwrapdata) * Hopratio;
            if (firsttime)
                ysangle = yangle;
                firsttime = false;
            else
                ysangle = ysangle + yunwrap;
            end
            % Convert magnitude and phase to complex numbers %
            ys = ymag .* complex(cos(ysangle), sin(ysangle));
            % Windowed IFFT %
            ywin  = win(idft(ys));
            % Overlap-add operation %
            olapadd  = [ywin(1:end-SynthesisLen,:) + yprevwin ; ywin(end-SynthesisLen+1:end,:)];
            yistfft  = olapadd(1:SynthesisLen, :);
            yprevwin = olapadd(SynthesisLen + 1:end, :);
            % Normalize %
            yistfft = yistfft * gain;
            % Log signal %
            logger(yistfft);
        end
        
        % Define final processed signal %
        release(reader);
        procSpeech = logger.Buffer(200:end)';
        procSpeech = resample(procSpeech, 8000, Fs);
        audiowrite('finaloutput.wav', procSpeech, 8000);
        
end

