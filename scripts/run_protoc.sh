DART_OUT=lib/src
JAVA_OUT=android/src/main/java
KOTLIN_OUT=android/src/main/kotlin
SWIFT_OUT=ios/Classes

PACKAGE=dev/yanshouwang/bluetooth_low_energy/proto

if [ -d $DART_OUT ]
then
    if [ -d ${DART_OUT}/proto ]
    then
        rm -rf ${DART_OUT}/proto/*
    fi
else
    mkdir -p $DART_OUT
fi

if [ -d $JAVA_OUT ]
then
    if [ -d ${JAVA_OUT}/$PACKAGE ]
    then
        rm -rf ${JAVA_OUT}/$PACKAGE/*
    fi
else
    mkdir -p $JAVA_OUT
fi

if [ -d $KOTLIN_OUT ]
then
    if [ -d ${KOTLIN_OUT}/$PACKAGE ]
    then
        rm -rf ${KOTLIN_OUT}/$PACKAGE/*
    fi
else
    mkdir -p $KOTLIN_OUT
fi

if [ -d $SWIFT_OUT ]
then
    if [ -d ${SWIFT_OUT}/proto ]
    then
        rm -rf ${SWIFT_OUT}/proto/*
    fi
else
    mkdir -p $SWIFT_OUT
fi

protoc \
    --dart_out $DART_OUT \
    --java_out $JAVA_OUT \
    --kotlin_out $KOTLIN_OUT \
    --swift_out $SWIFT_OUT \
    proto/*.proto