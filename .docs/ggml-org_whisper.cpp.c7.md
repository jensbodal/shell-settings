TITLE: Whisper CLI Usage and Options
DESCRIPTION: Comprehensive list of command-line arguments and options for the whisper-cli program, including audio processing parameters, output formats, and model configuration settings. The CLI supports features like multi-threading, language detection, translation, diarization, and various output formats including TXT, VTT, SRT, LRC, CSV, and JSON.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/cli/README.md#2025-04-11_snippet_0

LANGUAGE: shell
CODE:
```
./build/bin/whisper-cli -h

usage: ./build-pkg/bin/whisper-cli [options] file0.wav file1.wav ...

options:
  -h,        --help              [default] show this help message and exit
  -t N,      --threads N         [4      ] number of threads to use during computation
  -p N,      --processors N      [1      ] number of processors to use during computation
  -ot N,     --offset-t N        [0      ] time offset in milliseconds
  -on N,     --offset-n N        [0      ] segment index offset
  -d  N,     --duration N        [0      ] duration of audio to process in milliseconds
  -mc N,     --max-context N     [-1     ] maximum number of text context tokens to store
  -ml N,     --max-len N         [0      ] maximum segment length in characters
  -sow,      --split-on-word     [false  ] split on word rather than on token
  -bo N,     --best-of N         [5      ] number of best candidates to keep
  -bs N,     --beam-size N       [5      ] beam size for beam search
  -ac N,     --audio-ctx N       [0      ] audio context size (0 - all)
  -wt N,     --word-thold N      [0.01   ] word timestamp probability threshold
  -et N,     --entropy-thold N   [2.40   ] entropy threshold for decoder fail
  -lpt N,    --logprob-thold N   [-1.00  ] log probability threshold for decoder fail
  -tp,       --temperature N     [0.00   ] The sampling temperature, between 0 and 1
  -tpi,      --temperature-inc N [0.20   ] The increment of temperature, between 0 and 1
  -debug,    --debug-mode        [false  ] enable debug mode (eg. dump log_mel)
  -tr,       --translate         [false  ] translate from source language to english
  -di,       --diarize           [false  ] stereo audio diarization
  -tdrz,     --tinydiarize       [false  ] enable tinydiarize (requires a tdrz model)
  -nf,       --no-fallback       [false  ] do not use temperature fallback while decoding
  -otxt,     --output-txt        [false  ] output result in a text file
  -ovtt,     --output-vtt        [false  ] output result in a vtt file
  -osrt,     --output-srt        [false  ] output result in a srt file
  -olrc,     --output-lrc        [false  ] output result in a lrc file
  -owts,     --output-words      [false  ] output script for generating karaoke video
  -fp,       --font-path         [/System/Library/Fonts/Supplemental/Courier New Bold.ttf] path to a monospace font for karaoke video
  -ocsv,     --output-csv        [false  ] output result in a CSV file
  -oj,       --output-json       [false  ] output result in a JSON file
  -ojf,      --output-json-full  [false  ] include more information in the JSON file
  -of FNAME, --output-file FNAME [       ] output file path (without file extension)
  -np,       --no-prints         [false  ] do not print anything other than the results
  -ps,       --print-special     [false  ] print special tokens
  -pc,       --print-colors      [false  ] print colors
  -pp,       --print-progress    [false  ] print progress
  -nt,       --no-timestamps     [false  ] do not print timestamps
  -l LANG,   --language LANG     [en     ] spoken language ('auto' for auto-detect)
  -dl,       --detect-language   [false  ] exit after automatically detecting language
             --prompt PROMPT     [       ] initial prompt (max n_text_ctx/2 tokens)
  -m FNAME,  --model FNAME       [models/ggml-base.en.bin] model path
  -f FNAME,  --file FNAME        [       ] input WAV file path
  -oved D,   --ov-e-device DNAME [CPU    ] the OpenVINO device used for encode inference
  -dtw MODEL --dtw MODEL         [       ] compute token-level timestamps
  -ls,       --log-score         [false  ] log best decoder scores of tokens
  -ng,       --no-gpu            [false  ] disable GPU
  -fa,       --flash-attn        [false  ] flash attention
  --suppress-regex REGEX         [       ] regular expression matching tokens to suppress
  --grammar GRAMMAR              [       ] GBNF grammar to guide decoding
  --grammar-rule RULE            [       ] top-level GBNF grammar rule name
  --grammar-penalty N            [100.0  ] scales down logits of nongrammar tokens
```

----------------------------------------

TITLE: Building whisper.cpp with BLAS CPU Support
DESCRIPTION: Configures and builds the project with CMake, enabling OpenBLAS support for CPU acceleration.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_18

LANGUAGE: bash
CODE:
```
cmake -B build -DGGML_BLAS=1
cmake --build build -j --config Release
```

----------------------------------------

TITLE: Cloning the Whisper.cpp Repository
DESCRIPTION: This command clones the Whisper.cpp repository from GitHub to the local machine.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_0

LANGUAGE: bash
CODE:
```
git clone https://github.com/ggml-org/whisper.cpp.git
```

----------------------------------------

TITLE: Running whisper-stream with Sliding Window and VAD
DESCRIPTION: Command to run whisper-stream in sliding window mode with Voice Activity Detection. Setting step to 0 enables the sliding window, while the -vth parameter controls the VAD threshold for speech detection.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/stream/README.md#2025-04-11_snippet_1

LANGUAGE: bash
CODE:
```
./build/bin/whisper-stream -m ./models/ggml-base.en.bin -t 6 --step 0 --length 30000 -vth 0.6
```

----------------------------------------

TITLE: Generating Word-level Timestamps with whisper-cli
DESCRIPTION: Command-line example showing how to use the -ml 1 flag to generate word-level timestamps with whisper.cpp. The output shows a detailed breakdown of timestamps for each word in the transcription.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_25

LANGUAGE: text
CODE:
```
$ ./build/bin/whisper-cli -m ./models/ggml-base.en.bin -f ./samples/jfk.wav -ml 1

whisper_model_load: loading model from './models/ggml-base.en.bin'
...
system_info: n_threads = 4 / 10 | AVX2 = 0 | AVX512 = 0 | NEON = 1 | FP16_VA = 1 | WASM_SIMD = 0 | BLAS = 1 |

main: processing './samples/jfk.wav' (176000 samples, 11.0 sec), 4 threads, 1 processors, lang = en, task = transcribe, timestamps = 1 ...

[00:00:00.000 --> 00:00:00.320]
[00:00:00.320 --> 00:00:00.370]   And
[00:00:00.370 --> 00:00:00.690]   so
[00:00:00.690 --> 00:00:00.850]   my
[00:00:00.850 --> 00:00:01.590]   fellow
[00:00:01.590 --> 00:00:02.850]   Americans
[00:00:02.850 --> 00:00:03.300]  ,
[00:00:03.300 --> 00:00:04.140]   ask
[00:00:04.140 --> 00:00:04.990]   not
[00:00:04.990 --> 00:00:05.410]   what
[00:00:05.410 --> 00:00:05.660]   your
[00:00:05.660 --> 00:00:06.260]   country
[00:00:06.260 --> 00:00:06.600]   can
[00:00:06.600 --> 00:00:06.840]   do
[00:00:06.840 --> 00:00:07.010]   for
[00:00:07.010 --> 00:00:08.170]   you
[00:00:08.170 --> 00:00:08.190]  ,
[00:00:08.190 --> 00:00:08.430]   ask
[00:00:08.430 --> 00:00:08.910]   what
[00:00:08.910 --> 00:00:09.040]   you
[00:00:09.040 --> 00:00:09.320]   can
[00:00:09.320 --> 00:00:09.440]   do
[00:00:09.440 --> 00:00:09.760]   for
[00:00:09.760 --> 00:00:10.020]   your
[00:00:10.020 --> 00:00:10.510]   country
[00:00:10.510 --> 00:00:11.000]  .
```

----------------------------------------

TITLE: Basic Transcription with Whisper in Ruby
DESCRIPTION: Demonstrates how to initialize a Whisper context with a model, configure transcription parameters, and transcribe an audio file. Parameters include language specification, time offsets, token limits, translation options, and formatting preferences.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/bindings/ruby/README.md#2025-04-11_snippet_0

LANGUAGE: ruby
CODE:
```
require "whisper"

whisper = Whisper::Context.new("base")

params = Whisper::Params.new(
  language: "en",
  offset: 10_000,
  duration: 60_000,
  max_text_tokens: 300,
  translate: true,
  print_timestamps: false,
  initial_prompt: "Initial prompt here."
)

whisper.transcribe("path/to/audio.wav", params) do |whole_text|
  puts whole_text
end
```

----------------------------------------

TITLE: Building whisper-stream with SDL2 Support
DESCRIPTION: Instructions for building the whisper-stream tool with SDL2 support for microphone capture. Includes package installation commands for different platforms and the necessary CMake commands.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/stream/README.md#2025-04-11_snippet_2

LANGUAGE: bash
CODE:
```
# Install SDL2
# On Debian based linux distributions:
sudo apt-get install libsdl2-dev

# On Fedora Linux:
sudo dnf install SDL2 SDL2-devel

# Install SDL2 on Mac OS
brew install sdl2

cmake -B build -DWHISPER_SDL2=ON
cmake --build build --config Release

./build/bin/whisper-stream
```

----------------------------------------

TITLE: Generating Karaoke-style Videos with whisper.cpp
DESCRIPTION: Commands to generate karaoke-style videos where the currently pronounced word is highlighted. The example shows how to use the -owts flag to create a bash script that uses ffmpeg to produce the video.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_27

LANGUAGE: bash
CODE:
```
./build/bin/whisper-cli -m ./models/ggml-base.en.bin -f ./samples/jfk.wav -owts
source ./samples/jfk.wav.wts
ffplay ./samples/jfk.wav.mp4
```

LANGUAGE: bash
CODE:
```
./build/bin/whisper-cli -m ./models/ggml-base.en.bin -f ./samples/mm0.wav -owts
source ./samples/mm0.wav.wts
ffplay ./samples/mm0.wav.mp4
```

LANGUAGE: bash
CODE:
```
./build/bin/whisper-cli -m ./models/ggml-base.en.bin -f ./samples/gb0.wav -owts
source ./samples/gb0.wav.wts
ffplay ./samples/gb0.wav.mp4
```

----------------------------------------

TITLE: Transcribing Audio with Whisper-CLI
DESCRIPTION: This command uses the built whisper-cli tool to transcribe an audio file (jfk.wav) using the Whisper model.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_3

LANGUAGE: bash
CODE:
```
./build/bin/whisper-cli -f samples/jfk.wav
```

----------------------------------------

TITLE: Downloading Whisper Model in GGML Format
DESCRIPTION: This script downloads a Whisper model converted to GGML format. The example uses the 'base.en' model.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_1

LANGUAGE: bash
CODE:
```
sh ./models/download-ggml-model.sh base.en
```

----------------------------------------

TITLE: Setting up Python Environment for OpenVINO (Linux/macOS)
DESCRIPTION: Creates a Python virtual environment and installs required dependencies for OpenVINO conversion on Linux and macOS.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_11

LANGUAGE: bash
CODE:
```
cd models
python3 -m venv openvino_conv_env
source openvino_conv_env/bin/activate
python -m pip install --upgrade pip
pip install -r requirements-openvino.txt
```

----------------------------------------

TITLE: Initializing and Using WhisperCpp in Java
DESCRIPTION: This snippet demonstrates how to initialize WhisperCpp, load a model, transcribe audio, and retrieve the transcribed text segments. It includes error handling and resource cleanup.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/bindings/java/README.md#2025-04-11_snippet_0

LANGUAGE: java
CODE:
```
import io.github.ggerganov.whispercpp.WhisperCpp;

public class Example {

    public static void main(String[] args) {
        WhisperCpp whisper = new WhisperCpp();
        // By default, models are loaded from ~/.cache/whisper/ and are usually named "ggml-${name}.bin"
        // or you can provide the absolute path to the model file.
        long context = whisper.initContext("base.en");
        try {
            var whisperParams = whisper.getFullDefaultParams(WhisperSamplingStrategy.WHISPER_SAMPLING_GREEDY);
            // custom configuration if required
            whisperParams.temperature_inc = 0f;

            var samples = readAudio(); // divide each value by 32767.0f
            whisper.fullTranscribe(whisperParams, samples);

            int segmentCount = whisper.getTextSegmentCount(context);
            for (int i = 0; i < segmentCount; i++) {
                String text = whisper.getTextSegment(context, i);
                System.out.println(segment.getText());
            }
        } finally {
             whisper.freeContext(context);
        }
     }
}
```

----------------------------------------

TITLE: Using Docker for Model Download and Transcription
DESCRIPTION: Demonstrates how to use Docker to download a model and transcribe an audio file using whisper.cpp.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_21

LANGUAGE: bash
CODE:
```
docker run -it --rm \
  -v path/to/models:/models \
  whisper.cpp:main "./models/download-ggml-model.sh base /models"

docker run -it --rm \
  -v path/to/models:/models \
  -v path/to/audios:/audios \
  whisper.cpp:main "./main -m /models/ggml-base.bin -f /audios/jfk.wav"
```

----------------------------------------

TITLE: Using Whisper XCFramework in Swift Projects
DESCRIPTION: Example of how to integrate the pre-built Whisper XCFramework into Swift projects using Swift Package Manager. This allows using the whisper.cpp library in iOS, visionOS, tvOS, and macOS applications without compiling from source.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_30

LANGUAGE: swift
CODE:
```
// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Whisper",
    targets: [
        .executableTarget(
            name: "Whisper",
            dependencies: [
                "WhisperFramework"
            ]),
        .binaryTarget(
            name: "WhisperFramework",
            url: "https://github.com/ggml-org/whisper.cpp/releases/download/v1.7.5/whisper-v1.7.5-xcframework.zip",
            checksum: "c7faeb328620d6012e130f3d705c51a6ea6c995605f2df50f6e1ad68c59c6c4a"
        )
    ]
)
```

----------------------------------------

TITLE: Building Whisper.cpp Project with CMake
DESCRIPTION: These commands build the Whisper.cpp project using CMake, creating a build directory and compiling the project in Release configuration.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_2

LANGUAGE: bash
CODE:
```
cmake -B build
cmake --build build --config Release
```

----------------------------------------

TITLE: Converting Audio to 16-bit WAV Format
DESCRIPTION: This ffmpeg command converts an input audio file to a 16-bit WAV format compatible with the whisper-cli tool.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_4

LANGUAGE: bash
CODE:
```
ffmpeg -i input.mp3 -ar 16000 -ac 1 -c:a pcm_s16le output.wav
```

----------------------------------------

TITLE: Using Pre-converted Whisper Models in Ruby
DESCRIPTION: Shows how to use pre-converted Whisper models, which are downloaded automatically on first use and then cached. Includes methods for accessing cached models, clearing the cache, and listing available pre-converted models.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/bindings/ruby/README.md#2025-04-11_snippet_1

LANGUAGE: ruby
CODE:
```
base_en = Whisper::Model.pre_converted_models["base.en"]
whisper = Whisper::Context.new(base_en)
```

LANGUAGE: ruby
CODE:
```
Whisper::Model.pre_converted_models["base"].clear_cache
```

LANGUAGE: ruby
CODE:
```
whisper = Whisper::Context.new("base.en")
```

LANGUAGE: ruby
CODE:
```
puts Whisper::Model.pre_converted_models.keys
# tiny
# tiny.en
# tiny-q5_1
# tiny.en-q5_1
# tiny-q8_0
# base
# base.en
# base-q5_1
# base.en-q5_1
# base-q8_0
#   :
#   :
```

----------------------------------------

TITLE: Using Segment Callbacks in Whisper Ruby
DESCRIPTION: Demonstrates how to register a callback that is triggered on each new segment during transcription. The callback receives segment information including text, timestamps, and speaker change indicators.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/bindings/ruby/README.md#2025-04-11_snippet_4

LANGUAGE: ruby
CODE:
```
# Add hook before calling #transcribe
params.on_new_segment do |segment|
  line = "[%{st} --> %{ed}] %{text}" % {
    st: format_time(segment.start_time),
    ed: format_time(segment.end_time),
    text: segment.text
  }
  line << " (speaker turned)" if segment.speaker_next_turn?
  puts line
end

whisper.transcribe("path/to/audio.wav", params)
```

----------------------------------------

TITLE: Running Basic Real-Time Transcription with whisper-stream
DESCRIPTION: Command to run the whisper-stream tool for real-time audio transcription from the microphone with a fixed step interval. This samples audio every 500ms and processes 5-second chunks using 8 threads.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/stream/README.md#2025-04-11_snippet_0

LANGUAGE: bash
CODE:
```
./build/bin/whisper-stream -m ./models/ggml-base.en.bin -t 8 --step 500 --length 5000
```

----------------------------------------

TITLE: Downloading the Whisper Base Model
DESCRIPTION: Command to download the English base model for Whisper, which is required for transcription.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/whisper.nvim/README.md#2025-04-11_snippet_1

LANGUAGE: shell
CODE:
```
./models/download-ggml-model.sh base.en
```

----------------------------------------

TITLE: Converting PyTorch Models to ggml Format
DESCRIPTION: Bash script demonstrating how to convert a PyTorch Whisper model to ggml format using the convert-pt-to-ggml.py script. The process includes creating a directory, running the conversion script, and moving the output file.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/models/README.md#2025-04-11_snippet_1

LANGUAGE: bash
CODE:
```
mkdir models/whisper-medium
python models/convert-pt-to-ggml.py ~/.cache/whisper/medium.pt ~/path/to/repo/whisper/ ./models/whisper-medium
mv ./models/whisper-medium/ggml-model.bin models/ggml-medium.bin
rmdir models/whisper-medium
```

----------------------------------------

TITLE: Downloading ggml Models with download-ggml-model.sh
DESCRIPTION: Example of downloading a pre-converted ggml model using the download-ggml-model.sh script. The command downloads the base.en model and outputs information about how to use it.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/models/README.md#2025-04-11_snippet_0

LANGUAGE: text
CODE:
```
$ ./download-ggml-model.sh base.en
Downloading ggml model base.en ...
models/ggml-base.en.bin          100%[=============================================>] 141.11M  5.41MB/s    in 22s
Done! Model 'base.en' saved in 'models/ggml-base.en.bin'
You can now use it like this:

  $ ./build/bin/whisper-cli -m models/ggml-base.en.bin -f samples/jfk.wav
```

----------------------------------------

TITLE: Defining Build Options for whisper.cpp
DESCRIPTION: Defines the available build options for the project, including general settings, debug options, sanitizers, and third-party library integrations. These options control the build behavior and feature set of whisper.cpp.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/CMakeLists.txt#2025-04-11_snippet_3

LANGUAGE: CMake
CODE:
```
#
# option list
#

# general
option(WHISPER_CCACHE "whisper: use ccache if available" ON)

# debug
option(WHISPER_ALL_WARNINGS           "whisper: enable all compiler warnings"                   ON)
option(WHISPER_ALL_WARNINGS_3RD_PARTY "whisper: enable all compiler warnings in 3rd party libs" OFF)

# build
option(WHISPER_FATAL_WARNINGS  "whisper: enable -Werror flag"               OFF)
option(WHISPER_USE_SYSTEM_GGML "whisper: use system-installed GGML library" OFF)

# sanitizers
option(WHISPER_SANITIZE_THREAD    "whisper: enable thread sanitizer"    OFF)
option(WHISPER_SANITIZE_ADDRESS   "whisper: enable address sanitizer"   OFF)
option(WHISPER_SANITIZE_UNDEFINED "whisper: enable undefined sanitizer" OFF)

# extra artifacts
option(WHISPER_BUILD_TESTS    "whisper: build tests"          ${WHISPER_STANDALONE})
option(WHISPER_BUILD_EXAMPLES "whisper: build examples"       ${WHISPER_STANDALONE})
option(WHISPER_BUILD_SERVER   "whisper: build server example" ${WHISPER_STANDALONE})

# 3rd party libs
option(WHISPER_CURL "whisper: use libcurl to download model from an URL" OFF)
option(WHISPER_SDL2 "whisper: support for libSDL2" OFF)

if (CMAKE_SYSTEM_NAME MATCHES "Linux")
    option(WHISPER_FFMPEG "whisper: support building and linking with ffmpeg libs (avcodec, swresample, ...)" OFF)
endif()

option(WHISPER_COREML                "whisper: enable Core ML framework"  OFF)
option(WHISPER_COREML_ALLOW_FALLBACK "whisper: allow non-CoreML fallback" OFF)
option(WHISPER_OPENVINO              "whisper: support for OpenVINO"      OFF)
```

----------------------------------------

TITLE: Building and Running Voice-Controlled Chess in Bash
DESCRIPTION: Commands for building the wchess project from source using CMake and running it with a Whisper model. The resulting program displays a chess board interface in the terminal and accepts voice commands for moves.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/wchess/README.md#2025-04-11_snippet_0

LANGUAGE: bash
CODE:
```
mkdir build && cd build
cmake -DWHISPER_SDL2=1 ..
make -j

./bin/wchess -m ../models/ggml-base.en.bin

Move: start

a b c d e f g h
r n b q k b n r 8
p p p p p p p p 7
. * . * . * . * 6
* . * . * . * . 5
. * . * . * . * 4
* . * . * . * . 3
P P P P P P P P 2
R N B Q K B N R 1

White's turn
[(l)isten/(p)ause/(q)uit]: 
```

----------------------------------------

TITLE: Loading Custom Whisper Models in Ruby
DESCRIPTION: Demonstrates how to use local model files and remotely hosted models in the Whisper context. Supports loading from local paths or remote URLs.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/bindings/ruby/README.md#2025-04-11_snippet_2

LANGUAGE: ruby
CODE:
```
whisper = Whisper::Context.new("path/to/your/model.bin")
```

LANGUAGE: ruby
CODE:
```
whisper = Whisper::Context.new("https://example.net/uri/of/your/model.bin")
# Or
whisper = Whisper::Context.new(URI("https://example.net/uri/of/your/model.bin"))
```

----------------------------------------

TITLE: Building Whisper.wasm with Emscripten
DESCRIPTION: This snippet shows how to clone the whisper.cpp repository, create a build directory, and compile the project using Emscripten for WebAssembly output. It uses CMake for build configuration.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/whisper.wasm/README.md#2025-04-11_snippet_0

LANGUAGE: bash
CODE:
```
# build using Emscripten
git clone https://github.com/ggml-org/whisper.cpp
cd whisper.cpp
mkdir build-em && cd build-em
emcmake cmake ..
make -j
```

----------------------------------------

TITLE: Running Whisper.cpp Node.js Addon Example
DESCRIPTION: Command to run the example Node.js script that uses the compiled Whisper.cpp addon. It demonstrates how to pass language, model path, and input file path as command-line arguments.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/addon.node/README.md#2025-04-11_snippet_3

LANGUAGE: shell
CODE:
```
cd examples/addon.node

node index.js --language='language' --model='model-path' --fname_inp='file-path'
```

----------------------------------------

TITLE: Accessing Whisper Model Information in Ruby
DESCRIPTION: Shows how to retrieve detailed information about the loaded Whisper model, including vocabulary size, context dimensions, network architecture parameters, and model type.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/bindings/ruby/README.md#2025-04-11_snippet_5

LANGUAGE: ruby
CODE:
```
whisper = Whisper::Context.new("base")
model = whisper.model

model.n_vocab # => 51864
model.n_audio_ctx # => 1500
model.n_audio_state # => 512
model.n_audio_head # => 8
model.n_audio_layer # => 6
model.n_text_ctx # => 448
model.n_text_state # => 512
model.n_text_head # => 8
model.n_text_layer # => 6
model.n_mels # => 80
model.ftype # => 1
model.type # => "base"
```

----------------------------------------

TITLE: Configuring WebAssembly Build Target for Whisper.cpp using CMake
DESCRIPTION: This CMake script configures the compilation of the Whisper speech recognition library to WebAssembly. It defines the target executable, links the Whisper library, and sets up Emscripten-specific link flags for thread support, memory management, and module export. The script also includes an optional configuration to embed the WASM binary directly in the JavaScript file for simpler deployment.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/bindings/javascript/CMakeLists.txt#2025-04-11_snippet_0

LANGUAGE: cmake
CODE:
```
set(TARGET libwhisper)

add_executable(${TARGET}
    emscripten.cpp
    )

target_link_libraries(${TARGET} PRIVATE
    whisper
    )

unset(EXTRA_FLAGS)

if (WHISPER_WASM_SINGLE_FILE)
    set(EXTRA_FLAGS "-s SINGLE_FILE=1")
    message(STATUS "Embedding WASM inside whisper.js")

    add_custom_command(
        TARGET ${TARGET} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_BINARY_DIR}/bin/libwhisper.js
        ${CMAKE_CURRENT_SOURCE_DIR}/whisper.js
        )

    add_custom_command(
        TARGET ${TARGET} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
        ${CMAKE_BINARY_DIR}/bin/libwhisper.worker.js
        ${CMAKE_CURRENT_SOURCE_DIR}/libwhisper.worker.js
        )
endif()

set_target_properties(${TARGET} PROPERTIES LINK_FLAGS " \
    --bind \
    -s MODULARIZE=1 \
    -s EXPORT_NAME=\"'whisper_factory'\" \
    -s FORCE_FILESYSTEM=1 \
    -s USE_PTHREADS=1 \
    -s PTHREAD_POOL_SIZE=8 \
    -s ALLOW_MEMORY_GROWTH=1 \
    ${EXTRA_FLAGS} \
    ")
```

----------------------------------------

TITLE: Generating Core ML Model for Whisper
DESCRIPTION: This script generates a Core ML model for the 'base.en' Whisper model, which can be used for accelerated inference on Apple Silicon devices.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_8

LANGUAGE: bash
CODE:
```
./models/generate-coreml-model.sh base.en
```

----------------------------------------

TITLE: Building and Running Real-time Audio Input Example
DESCRIPTION: Configures, builds, and runs the real-time audio input example using SDL2.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_22

LANGUAGE: bash
CODE:
```
cmake -B build -DWHISPER_SDL2=ON
cmake --build build --config Release
./build/bin/whisper-stream -m ./models/ggml-base.en.bin -t 8 --step 500 --length 5000
```

----------------------------------------

TITLE: Speaker Segmentation using tinydiarize in whisper.cpp
DESCRIPTION: Example of using tinydiarize for speaker segmentation in whisper.cpp. It demonstrates how to download a compatible model and run it with the -tdrz flag, which adds speaker turn annotations to the transcription.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_26

LANGUAGE: python
CODE:
```
# download a tinydiarize compatible model
./models/download-ggml-model.sh small.en-tdrz

# run as usual, adding the "-tdrz" command-line argument
./build/bin/whisper-cli -f ./samples/a13.wav -m ./models/ggml-small.en-tdrz.bin -tdrz
...
main: processing './samples/a13.wav' (480000 samples, 30.0 sec), 4 threads, 1 processors, lang = en, task = transcribe, tdrz = 1, timestamps = 1 ...
...
[00:00:00.000 --> 00:00:03.800]   Okay Houston, we've had a problem here. [SPEAKER_TURN]
[00:00:03.800 --> 00:00:06.200]   This is Houston. Say again please. [SPEAKER_TURN]
[00:00:06.200 --> 00:00:08.260]   Uh Houston we've had a problem.
[00:00:08.260 --> 00:00:11.320]   We've had a main beam up on a volt. [SPEAKER_TURN]
[00:00:11.320 --> 00:00:13.820]   Roger main beam interval. [SPEAKER_TURN]
[00:00:13.820 --> 00:00:15.100]   Uh uh [SPEAKER_TURN]
[00:00:15.100 --> 00:00:18.020]   So okay stand, by thirteen we're looking at it. [SPEAKER_TURN]
[00:00:18.020 --> 00:00:25.740]   Okay uh right now uh Houston the uh voltage is uh is looking good um.
[00:00:27.620 --> 00:00:29.940]   And we had a a pretty large bank or so.
```

----------------------------------------

TITLE: Compiling Whisper.cpp Node.js Addon with cmake-js
DESCRIPTION: Command to compile the Whisper.cpp Node.js addon using cmake-js. It specifies the target name as 'addon.node' and sets the build type to 'Release'.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/addon.node/README.md#2025-04-11_snippet_1

LANGUAGE: shell
CODE:
```
npx cmake-js compile -T addon.node -B Release
```

----------------------------------------

TITLE: Running the Whisper Benchmarking Tool with a Small English Model
DESCRIPTION: This command demonstrates how to run the whisper-bench tool on the small.en model using 4 threads. The output shows detailed model information and performance metrics, including load time, encoding time per layer, and total execution time. The benchmark results can be submitted to a GitHub issue for comparison.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/bench/README.md#2025-04-11_snippet_0

LANGUAGE: bash
CODE:
```
# run the bench too on the small.en model using 4 threads
$ ./build/bin/whisper-bench -m ./models/ggml-small.en.bin -t 4

whisper_model_load: loading model from './models/ggml-small.en.bin'
whisper_model_load: n_vocab       = 51864
whisper_model_load: n_audio_ctx   = 1500
whisper_model_load: n_audio_state = 768
whisper_model_load: n_audio_head  = 12
whisper_model_load: n_audio_layer = 12
whisper_model_load: n_text_ctx    = 448
whisper_model_load: n_text_state  = 768
whisper_model_load: n_text_head   = 12
whisper_model_load: n_text_layer  = 12
whisper_model_load: n_mels        = 80
whisper_model_load: f16           = 1
whisper_model_load: type          = 3
whisper_model_load: mem_required  = 1048.00 MB
whisper_model_load: adding 1607 extra tokens
whisper_model_load: ggml ctx size = 533.05 MB
whisper_model_load: memory size =    68.48 MB 
whisper_model_load: model size  =   464.44 MB

whisper_print_timings:     load time =   240.82 ms
whisper_print_timings:      mel time =     0.00 ms
whisper_print_timings:   sample time =     0.00 ms
whisper_print_timings:   encode time =  1062.21 ms / 88.52 ms per layer
whisper_print_timings:   decode time =     0.00 ms / 0.00 ms per layer
whisper_print_timings:    total time =  1303.04 ms

system_info: n_threads = 4 | AVX2 = 0 | AVX512 = 0 | NEON = 1 | FP16_VA = 1 | WASM_SIMD = 0 | BLAS = 1 | 

If you wish, you can submit these results here:

  https://github.com/ggml-org/whisper.cpp/issues/89

Please include the following information:

  - CPU model
  - Operating system
  - Compiler
```

----------------------------------------

TITLE: Building whisper.cpp with NVIDIA GPU Support
DESCRIPTION: Configures and builds the project with CMake, enabling CUDA support for NVIDIA GPUs.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_16

LANGUAGE: bash
CODE:
```
cmake -B build -DGGML_CUDA=1
cmake --build build -j --config Release
```

----------------------------------------

TITLE: Converting Hugging Face Fine-tuned Models to ggml Format
DESCRIPTION: Bash script showing how to convert Hugging Face fine-tuned Whisper models to ggml format. The process includes cloning necessary repositories, downloading the model, and running the conversion script.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/models/README.md#2025-04-11_snippet_2

LANGUAGE: bash
CODE:
```
git clone https://github.com/openai/whisper
git clone https://github.com/ggml-org/whisper.cpp

# clone HF fine-tuned model (this is just an example)
git clone https://huggingface.co/openai/whisper-medium

# convert the model to ggml
python3 ./whisper.cpp/models/convert-h5-to-ggml.py ./whisper-medium/ ./whisper .
```

----------------------------------------

TITLE: Controlling Text Segment Length in Transcription
DESCRIPTION: Demonstrates how to limit the length of generated text segments during transcription.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_24

LANGUAGE: bash
CODE:
```
./build/bin/whisper-cli -m ./models/ggml-base.en.bin -f ./samples/jfk.wav -ml 16
```

----------------------------------------

TITLE: Sample Output of Whisper.cpp Node.js Test Run
DESCRIPTION: Example output showing the model loading process, system information, and transcription results from running the test script. Includes detailed timing metrics for different processing stages.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/bindings/javascript/README.md#2025-04-11_snippet_1

LANGUAGE: text
CODE:
```
$ node --experimental-wasm-threads --experimental-wasm-simd ../tests/test-whisper.js

whisper_model_load: loading model from 'whisper.bin'
whisper_model_load: n_vocab       = 51864
whisper_model_load: n_audio_ctx   = 1500
whisper_model_load: n_audio_state = 512
whisper_model_load: n_audio_head  = 8
whisper_model_load: n_audio_layer = 6
whisper_model_load: n_text_ctx    = 448
whisper_model_load: n_text_state  = 512
whisper_model_load: n_text_head   = 8
whisper_model_load: n_text_layer  = 6
whisper_model_load: n_mels        = 80
whisper_model_load: f16           = 1
whisper_model_load: type          = 2
whisper_model_load: adding 1607 extra tokens
whisper_model_load: mem_required  =  506.00 MB
whisper_model_load: ggml ctx size =  140.60 MB
whisper_model_load: memory size   =   22.83 MB
whisper_model_load: model size    =  140.54 MB

system_info: n_threads = 8 / 10 | AVX = 0 | AVX2 = 0 | AVX512 = 0 | NEON = 0 | F16C = 0 | FP16_VA = 0 | WASM_SIMD = 1 | BLAS = 0 |

operator(): processing 176000 samples, 11.0 sec, 8 threads, 1 processors, lang = en, task = transcribe ...

[00:00:00.000 --> 00:00:11.000]   And so my fellow Americans, ask not what your country can do for you, ask what you can do for your country.

whisper_print_timings:     load time =   162.37 ms
whisper_print_timings:      mel time =   183.70 ms
whisper_print_timings:   sample time =     4.27 ms
whisper_print_timings:   encode time =  8582.63 ms / 1430.44 ms per layer
whisper_print_timings:   decode time =   436.16 ms / 72.69 ms per layer
whisper_print_timings:    total time =  9370.90 ms
```

----------------------------------------

TITLE: Building whisper.cpp with FFmpeg Support (Linux)
DESCRIPTION: Configures and builds the project with CMake, enabling FFmpeg integration for additional audio format support on Linux.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_20

LANGUAGE: bash
CODE:
```
cmake -B build -D WHISPER_FFMPEG=yes
cmake --build build
```

----------------------------------------

TITLE: Building whisper.cpp with Vulkan GPU Support
DESCRIPTION: Configures and builds the project with CMake, enabling Vulkan support for cross-vendor GPU acceleration.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_17

LANGUAGE: bash
CODE:
```
cmake -B build -DGGML_VULKAN=1
cmake --build build -j --config Release
```

----------------------------------------

TITLE: Configuring and Building Whisper Server with CMake
DESCRIPTION: Sets up the whisper-server target by defining source files, including dependencies, linking libraries, and handling platform-specific requirements. The configuration links the common, json_cpp, and whisper libraries, adds threading support, and includes Windows-specific socket libraries when building on Windows.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/server/CMakeLists.txt#2025-04-11_snippet_0

LANGUAGE: CMake
CODE:
```
set(TARGET whisper-server)
add_executable(${TARGET} server.cpp httplib.h)

include(DefaultTargetOptions)

target_link_libraries(${TARGET} PRIVATE common json_cpp whisper ${CMAKE_THREAD_LIBS_INIT})

if (WIN32)
    target_link_libraries(${TARGET} PRIVATE ws2_32)
endif()

install(TARGETS ${TARGET} RUNTIME)
```

----------------------------------------

TITLE: Running Transcription with Confidence Color-coding
DESCRIPTION: Executes the whisper-cli with color-coded confidence output for transcribed text.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_23

LANGUAGE: bash
CODE:
```
./build/bin/whisper-cli -m models/ggml-base.en.bin -f samples/gb0.wav --print-colors
```

----------------------------------------

TITLE: Building whisper.cpp with OpenVINO Support
DESCRIPTION: Configures and builds the project with CMake, enabling OpenVINO support.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_15

LANGUAGE: bash
CODE:
```
cmake -B build -DWHISPER_OPENVINO=1
cmake --build build -j --config Release
```

----------------------------------------

TITLE: Whisper Server Model Loading API Request
DESCRIPTION: cURL command example for loading a new model file into the server.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/server/README.md#2025-04-11_snippet_2

LANGUAGE: bash
CODE:
```
curl 127.0.0.1:8080/load \
-H "Content-Type: multipart/form-data" \
-F model="<path-to-model-file>"
```

----------------------------------------

TITLE: Building Whisper Command with SDL2 Dependencies
DESCRIPTION: Instructions for building the whisper-command tool with SDL2 library dependencies across different operating systems including Debian, Fedora, and MacOS.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/command/README.md#2025-04-11_snippet_2

LANGUAGE: bash
CODE:
```
# Install SDL2
# On Debian based linux distributions:
sudo apt-get install libsdl2-dev

# On Fedora Linux:
sudo dnf install SDL2 SDL2-devel

# Install SDL2 on Mac OS
brew install sdl2

cmake -B build -DWHISPER_SDL2=ON
cmake --build build --config Release
```

----------------------------------------

TITLE: Building Whisper.cpp with Core ML Support
DESCRIPTION: These commands build Whisper.cpp with Core ML support enabled, allowing for accelerated inference on Apple Silicon devices.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_9

LANGUAGE: bash
CODE:
```
cmake -B build -DWHISPER_COREML=1
cmake --build build -j --config Release
```

----------------------------------------

TITLE: Creating Video Comparisons of Different Whisper Models
DESCRIPTION: Commands to generate a video that compares the transcription quality of different whisper.cpp models on the same audio input. Uses a dedicated script and ffmpeg to produce a side-by-side comparison.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_28

LANGUAGE: bash
CODE:
```
./scripts/bench-wts.sh samples/jfk.wav
ffplay ./samples/jfk.wav.all.mp4
```

----------------------------------------

TITLE: Building and Running whisper-talk-llama with SDL2
DESCRIPTION: Instructions for installing SDL2 dependencies, building the whisper-talk-llama executable, and running it with specific command line arguments for Whisper and LLaMA models.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/talk-llama/README.md#2025-04-11_snippet_0

LANGUAGE: bash
CODE:
```
# Install SDL2
# On Debian based linux distributions:
sudo apt-get install libsdl2-dev

# On Fedora Linux:
sudo dnf install SDL2 SDL2-devel

# Install SDL2 on Mac OS
brew install sdl2

# Build the "whisper-talk-llama" executable
cmake -B build -S . -DWHISPER_SDL2=ON
cmake --build build --config Release

# Run it
./build/bin/whisper-talk-llama -mw ./models/ggml-small.en.bin -ml ../llama.cpp/models/llama-13b/ggml-model-q4_0.gguf -p "Georgi" -t 8
```

----------------------------------------

TITLE: Running Whisper Command with Default Settings
DESCRIPTION: Commands for running the voice assistant with default arguments and small model. Includes specific optimization parameters for Raspberry Pi deployment.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/command/README.md#2025-04-11_snippet_0

LANGUAGE: bash
CODE:
```
# Run with default arguments and small model
./whisper-command -m ./models/ggml-small.en.bin -t 8

# On Raspberry Pi, use tiny or base models + "-ac 768" for better performance
./whisper-command -m ./models/ggml-tiny.en.bin -ac 768 -t 3 -c 0
```

----------------------------------------

TITLE: Whisper Server Command Line Options
DESCRIPTION: Comprehensive list of command-line arguments for configuring the whisper.cpp server, including threading, processing, model, and server options.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/server/README.md#2025-04-11_snippet_0

LANGUAGE: plaintext
CODE:
```
./build/bin/whisper-server -h

usage: ./build/bin/whisper-server [options]

options:
  -h,        --help              [default] show this help message and exit
  -t N,      --threads N         [4      ] number of threads to use during computation
  -p N,      --processors N      [1      ] number of processors to use during computation
  -ot N,     --offset-t N        [0      ] time offset in milliseconds
  -on N,     --offset-n N        [0      ] segment index offset
  -d  N,     --duration N        [0      ] duration of audio to process in milliseconds
  -mc N,     --max-context N     [-1     ] maximum number of text context tokens to store
  -ml N,     --max-len N         [0      ] maximum segment length in characters
  -sow,      --split-on-word     [false  ] split on word rather than on token
  -bo N,     --best-of N         [2      ] number of best candidates to keep
  -bs N,     --beam-size N       [-1     ] beam size for beam search
  -wt N,     --word-thold N      [0.01   ] word timestamp probability threshold
  -et N,     --entropy-thold N   [2.40   ] entropy threshold for decoder fail
  -lpt N,    --logprob-thold N   [-1.00  ] log probability threshold for decoder fail
  -debug,    --debug-mode        [false  ] enable debug mode (eg. dump log_mel)
  -tr,       --translate         [false  ] translate from source language to english
  -di,       --diarize           [false  ] stereo audio diarization
  -tdrz,     --tinydiarize       [false  ] enable tinydiarize (requires a tdrz model)
  -nf,       --no-fallback       [false  ] do not use temperature fallback while decoding
  -ps,       --print-special     [false  ] print special tokens
  -pc,       --print-colors      [false  ] print colors
  -pr,       --print-realtime    [false  ] print output in realtime
  -pp,       --print-progress    [false  ] print progress
  -nt,       --no-timestamps     [false  ] do not print timestamps
  -l LANG,   --language LANG     [en     ] spoken language ('auto' for auto-detect)
  -dl,       --detect-language   [false  ] exit after automatically detecting language
             --prompt PROMPT     [       ] initial prompt
  -m FNAME,  --model FNAME       [models/ggml-base.en.bin] model path
  -oved D,   --ov-e-device DNAME [CPU    ] the OpenVINO device used for encode inference
  --host HOST,                   [127.0.0.1] Hostname/ip-adress for the server
  --port PORT,                   [8080   ] Port number for the server
  --convert,                     [false  ] Convert audio to WAV, requires ffmpeg on the server
```

----------------------------------------

TITLE: Building and Testing Whisper.cpp Java Bindings
DESCRIPTION: This bash script demonstrates how to clone the whisper.cpp repository, navigate to the Java bindings directory, and run the Gradle build process for testing the Java bindings.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/bindings/java/README.md#2025-04-11_snippet_1

LANGUAGE: bash
CODE:
```
git clone https://github.com/ggml-org/whisper.cpp.git
cd whisper.cpp/bindings/java

./gradlew build
```

----------------------------------------

TITLE: Quantizing Whisper Model
DESCRIPTION: This command quantizes a Whisper model using the Q5_0 method, which reduces model size and can improve inference speed.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/README.md#2025-04-11_snippet_6

LANGUAGE: bash
CODE:
```
./build/bin/quantize models/ggml-base.en.bin models/ggml-base.en-q5_0.bin q5_0
```

----------------------------------------

TITLE: GGML Backend Configuration Options
DESCRIPTION: Defines CMake options for various hardware acceleration backends and their settings, including CUDA, Metal, Vulkan, OpenCL, and others. Each option controls specific features and behaviors of the respective backend.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/ggml/CMakeLists.txt#2025-04-11_snippet_7

LANGUAGE: cmake
CODE:
```
option(GGML_ACCELERATE "ggml: enable Accelerate framework" ON)
option(GGML_BLAS "ggml: use BLAS" ${GGML_BLAS_DEFAULT})
set(GGML_BLAS_VENDOR ${GGML_BLAS_VENDOR_DEFAULT} CACHE STRING "ggml: BLAS library vendor")
option(GGML_LLAMAFILE "ggml: use LLAMAFILE" ${GGML_LLAMAFILE_DEFAULT})
```

----------------------------------------

TITLE: Downloading LibriSpeech Audio Files
DESCRIPTION: Command to download the necessary audio files from the LibriSpeech project for testing purposes.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/tests/librispeech/README.md#2025-04-11_snippet_1

LANGUAGE: bash
CODE:
```
$ make get-audio
```

----------------------------------------

TITLE: Running whisper-talk-llama with Session Support
DESCRIPTION: Example command for running whisper-talk-llama with session management enabled, which allows for maintaining conversation context across multiple interactions by saving and loading model state.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/talk-llama/README.md#2025-04-11_snippet_1

LANGUAGE: bash
CODE:
```
./build/bin/whisper-talk-llama --session ./my-session-file -mw ./models/ggml-small.en.bin -ml ../llama.cpp/models/llama-13b/ggml-model-q4_0.gguf -p "Georgi" -t 8
```

----------------------------------------

TITLE: Building whisper.cpp from the Project Root Directory
DESCRIPTION: Commands to compile the whisper-cli executable and download a model in ggml format. These steps are prerequisites for running the LibriSpeech tests.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/tests/librispeech/README.md#2025-04-11_snippet_0

LANGUAGE: bash
CODE:
```
$ # Execute the commands below in the project root dir.
$ cmake -B build
$ cmake --build build --config Release
$ ./models/download-ggml-model.sh tiny
```

----------------------------------------

TITLE: Starting a Local HTTP Server for Whisper.wasm
DESCRIPTION: This snippet demonstrates how to start a local HTTP server using Python to serve the Whisper.wasm example. It also provides the URL to access the example in a web browser.
SOURCE: https://github.com/ggml-org/whisper.cpp/blob/master/examples/whisper.wasm/README.md#2025-04-11_snippet_1

LANGUAGE: console
CODE:
```
python3 examples/server.py
```
