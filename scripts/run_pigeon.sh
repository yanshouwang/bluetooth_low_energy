DART_OUT=lib/src/pigeon
DART_TEST_OUT=test/pigeon
JAVA_OUT=android/src/main/java/dev/yanshouwang/bluetooth_low_energy/pigeon
SWIFT_OUT=ios/Classes/pigeon

if [ -d $DART_OUT ]
then
    rm -rf ${DART_OUT}/*
else
    mkdir -p $DART_OUT
fi

if [ -d $DART_TEST_OUT ]
then
    rm -rf ${DART_TEST_OUT}/*
else
    mkdir -p $DART_TEST_OUT
fi

if [ -d $JAVA_OUT ]
then
    rm -rf ${JAVA_OUT}/*
else
    mkdir -p $JAVA_OUT
fi

if [ -d $SWIFT_OUT ]
then
    rm -rf ${SWIFT_OUT}/*
else
    mkdir -p $SWIFT_OUT
fi

flutter pub run pigeon --input pigeon/api.dart