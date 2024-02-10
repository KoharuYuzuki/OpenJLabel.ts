set -eu

CURRENT_DIR=$(cd $(dirname $0); pwd)
TOOLS_DIR="/tools"

BUILD_DIR="$CURRENT_DIR/wasm"
EMSDK_DIR="$TOOLS_DIR/emsdk"
LIBOPENJTALK_DIR="$TOOLS_DIR/libopenjtalk"
OPENJLABEL_DIR="$TOOLS_DIR/openjlabel"

EMSDK_REPO="https://github.com/emscripten-core/emsdk.git"
LIBOPENJTALK_REPO="https://github.com/KoharuYuzuki/LibOpenJTalk.git"
OPENJLABEL_REPO="https://github.com/KoharuYuzuki/OpenJLabel.git"

mkdir -p "$BUILD_DIR"

if [ ! -d $EMSDK_DIR ]; then
  mkdir -p "$EMSDK_DIR"
  git clone "$EMSDK_REPO" "$EMSDK_DIR"

  pushd "$EMSDK_DIR"
  ./emsdk install latest
  popd
fi

pushd "$EMSDK_DIR"
./emsdk activate latest
source "./emsdk_env.sh"
popd

if [ ! -d $LIBOPENJTALK_DIR ]; then
  mkdir -p "$LIBOPENJTALK_DIR"
  git clone "$LIBOPENJTALK_REPO" "$LIBOPENJTALK_DIR"

  pushd "$LIBOPENJTALK_DIR"
  mv -f configure.ac configure.ac.old
  sed "s/AC_OUTPUT/CXXFLAGS=\"\$CFLAGS -std=c++14\"\nAC_OUTPUT/" configure.ac.old > configure.ac
  autoreconf -ivf
  ./build_wasm.sh
  popd
fi

if [ ! -d $OPENJLABEL_DIR ]; then
  mkdir -p "$OPENJLABEL_DIR"
  git clone "$OPENJLABEL_REPO" "$OPENJLABEL_DIR"
fi

pushd "$LIBOPENJTALK_DIR"
emcc \
  "$OPENJLABEL_DIR/openjlabel.cpp" \
  "./library/lang/wasm-libopenjtalk-lang.a" \
  -I "./library/lang" \
  -I "./mecab/src" \
  -I "./njd" \
  -I "./jpcommon" \
  -I "./text2mecab" \
  -I "./mecab2njd" \
  -I "./njd_set_pronunciation" \
  -I "./njd_set_digit" \
  -I "./njd_set_accent_phrase" \
  -I "./njd_set_accent_type" \
  -I "./njd_set_long_vowel" \
  -I "./njd_set_unvoiced_vowel" \
  -I "./njd2jpcommon" \
  -I "./utfcpp/source" \
  -O3 \
  -s INVOKE_RUN=0 \
  -s ALLOW_MEMORY_GROWTH=1 \
  -s MODULARIZE=1 \
  -s EXPORT_ES6=1 \
  -s USE_ES6_IMPORT_META=1 \
  -s EXPORT_NAME=openjlabel \
  -s EXPORTED_RUNTIME_METHODS=callMain,FS \
  -o "$BUILD_DIR/openjlabel.js"
popd
