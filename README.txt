||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|----------------------------------------------------------------------------------|
|------------;###'------#####----------------------____________________________----|
|--------'###:::::###`--#:::#----------------------|                          |----|
|------##+:::::::::::##-#:::#----------------------|       GEORGIA TECH       |----|
|-----#+:::::::::::::::##:::#----------------------|         ECE 6255         |----|
|----#::::::::::::::::::#:::#----------------------|                          |----|
|---#:::::::####'####:::::::#----------------------|     ~~~~~~~~~~~~~~~~     |----|
|--#::::::##---------##:::::#----------------------|                          |----|
|-#':::::#-------------##:::#----------------------|      WILLIAM MORLAN      |----|
|-#:::::#---------------#####----------------------|       ALEX PARISI        |----|
|-#:::::#----------###########################-----|     VASUNDHARA RAWAT     |----|
|#:::::#-----------#:::::::::::::::::::::::::#-----|                          |----|
|#:::::#-----------#:::::::::::::::::::::::::#-----|     ~~~~~~~~~~~~~~~~     |----|
|#:::::#-----------#:::::::::::::::::::::::::#-----|                          |----|
|#:::::#-----------#::###:::###:::'#######:::#-----|    TIME-STRECHING AND    |----|
|-#:::::#----------#::#-#:::#-#:::'#-----#:::#-----|    PHASE-SHIFTING FOR    |----|
|-#:::::#----------#::#-#:::#-#:::'#-----#:::#-----|      SPEECH SIGNALS      |----|
|-#::::::#'--------#####::::#-#:::'#-----#####-----|__________________________|----|
|--#::::::##---------##:::::#-#:::'#-----------------------------------------------|
|---#:::::::#########:::::::#-#:::'#-----------------------------------------------|
|---'#::::::::::::::::::::::#-#:::'#-----------------------------------------------|
|-----#::::::::::::::::+#:::#-#:::'#-----------------------------------------------|
|------##:::::::::::::###:::#-#:::'#-----------------------------------------------|
|--------###:::::::###--#####-#:::'#-----------------------------------------------|
|-----------#######--------####:::'###---------------------------------------------|
|--------------------------#:::::::::#---------------------------------------------|
|--------------------------#:::::::::#---------------------------------------------|
|--------------------------#:::::::::#---------------------------------------------|
|--------------------------###########---------------------------------------------|
|----------------------------------------------------------------------------------|
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|                                                                                  |
|                            ~~~%%%~~~ README ~~~%%%~~~                            |
|                                                                                  |
|       NOTES:                                                                     |
|                                                                                  |
|                    This code has been tested for MATLAB version                  |
|                    R2016b. We cannot imagine this code will have                 |
|                    any errors in other versions of MATLAB, but                   |
|                    cannot verify this.                                           |
|                                                                                  |
|                    This code relies upon the 'DSP System Toolbox'                |
|                    for MATLAB, which should be provided in any                   |
|                    MATLAB installation from Georgia Tech's OIT.                  |
|                                                                                  |
|       PATHS:                                                                     |
|                                                                                  |
|                    Please verify that before running the code, the               |
|                    active directory contains all files specified below           |
|                    in the section titled "CONTENTS".                             |
|                                                                                  |
|       CONTENTS:                                                                  |
|                                                                                  |
|                    changePitchLength.m                                           |
|                    PhaseVocoder.m                                                |
|                    RunMe.m                                                       |
|                    README.txt                                                    |
|                    data.xls                                                      |
|                    ***** AUDIO FILES *****                                       |
|                                                                                  |
|       INSTRUCTIONS:                                                              |
|                                                                                  |
|                    1) Choose which audio file you would like to process          |
|                       and uncomment it within "RunMe.m". There is already        |
|                       an example provided so this step is not necessary.         |
|                                                                                  |
|                    2) Within "data.xls", define the region(s) in which you       |
|                       like to edit. Use the following format:                    |
|                                                                                  |
|                          [ StartTime, EndTime, Duration, Pitch ]                 |
|                                                                                  |
|                       You can put multiple blocks of processing in this          |
|                       file by entering multiple lines. As with step (1),         |
|                       an example is already provided.                            |
|                                                                                  |
|                    3) Run the file "RunMe.m". There are no inputs for            |
|                       this script.                                               |
|                                                                                  |
|       WARNINGS:                                                                  |
|                                                                                  |
|                    -- Do not define a processing block within a word.            |
|                       Make sure the entire word or phrase is encapsulated        |
|                       by the individual processing block. Changing the           |
|                       time or pitch mid-word produces a very undesireable        |
|                       sound.                                                     |
|                                                                                  |
|                    -- Make sure two processing blocks do not overlap with        |
|                       their start and end times. The algorithm works by          |
|                       processing the latest blocks first. This preserves         |
|                       the indexing of blocks that would occur at an              |
|                       earlier time in the signal. Had this been done the         |
|                       other way, any time stretching will affect the             |
|                       indexing of the next block since the overall signal        |
|                       now has a new duration. The same effect occurs if          |
|                       blocks have start/end times that overlap.                  |
|                                                                                  |
|                    -- There are limits on the amount of time-stretching          |
|                       and pitch-scaling this method can perform. Make sure       |
|                       the amount of streching or scaling isn't "extreme"         |
|                       compared to the original duration/pitch - this             |
|                       measure is hard to define.                                 |
|                                                                                  |
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||