Simple Java main:

```
$ javac Hello.java
$ java Hello
Hello, World!
```

Build a base container:

```
$ docker build --build-arg USER=${USER} --build-arg USER_ID="$(id -u)" --build-arg USER_GID="$(id -g)" -t devcontainer .
```

Try and build a native image inside it:

```
$ docker run -ti -v `pwd`:/work devcontainer
$ native-image Hello
native-image Hello.java 
========================================================================================================================
GraalVM Native Image: Generating 'hello.java' (executable)...
========================================================================================================================
[1/8] Initializing...                                                                                    (0.0s @ 0.13GB)
Error: Main entry point class 'Hello.java' neither found on 
classpath: '/work' nor
modulepath: '/opt/oracle-graalvm-jdk21/lib/svm/graal-microservices.jar:/opt/oracle-graalvm-jdk21/lib/svm/library-support.jar'.
$ javac Hello.java 
$ native-image Hello      
========================================================================================================================
GraalVM Native Image: Generating 'hello' (executable)...
========================================================================================================================
[1/8] Initializing...
                                                                                    (0.0s @ 0.15GB)
Error: Default native-compiler executable 'gcc' not found via environment variable PATH
Error: To prevent native-toolchain checking provide command-line option -H:-CheckToolchain
...
```

So we need to install a bunch of pre-requesites. The [recommended](https://www.graalvm.org/latest/reference-manual/native-image/#prerequisites) Ubuntu way of doing it works:

```
$ sudo apt-get install build-essential libz-dev zlib1g-dev
$ native-image Hello
$ ./hello
Hello, World!
```

[Nix](https://nixos.org/download/) route:

```
$ . ~/.nix-profile/etc/profile.d/nix.sh
$ nix-shell
$ native-image Hello
...
> java.lang.RuntimeException: There was an error linking the native image: Linker command exited with 1

Based on the linker command output, possible reasons for this include:
1. It appears as though libz:.a is missing. Please install it.

Linker command executed:
/nix/store/kvlhk0gpm2iz1asbw1xjac2ch0r8kyw9-gcc-wrapper-13.2.0/bin/gcc -z noexecstack -Wl,--gc-sections -Wl,--version-script,/tmp/SVM-16553447527662537392/exported_symbols.list -Wl,-x -o /work/hello hello.o /opt/oracle-graalvm-jdk21/lib/svm/clibraries/linux-amd64/liblibchelper.a /opt/oracle-graalvm-jdk21/lib/static/linux-amd64/glibc/libnet.a /opt/oracle-graalvm-jdk21/lib/static/linux-amd64/glibc/libnio.a /opt/oracle-graalvm-jdk21/lib/static/linux-amd64/glibc/libjava.a /opt/oracle-graalvm-jdk21/lib/svm/clibraries/linux-amd64/libjvm.a -Wl,--export-dynamic -v -L/tmp/SVM-16553447527662537392 -L/opt/oracle-graalvm-jdk21/lib/static/linux-amd64/glibc -L/opt/oracle-graalvm-jdk21/lib/svm/clibraries/linux-amd64 -lz -ldl -lpthread -lrt

Linker command output:
Using built-in specs.
COLLECT_GCC=/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/bin/gcc
COLLECT_LTO_WRAPPER=/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/libexec/gcc/x86_64-unknown-linux-gnu/13.2.0/lto-wrapper
Target: x86_64-unknown-linux-gnu
Configured with: ../gcc-13.2.0/configure --prefix=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-gcc-13.2.0 --with-gmp-include=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-gmp-6.3.0-dev/include --with-gmp-lib=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-gmp-6.3.0/lib --with-mpfr-include=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-mpfr-4.2.1-dev/include --with-mpfr-lib=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-mpfr-4.2.1/lib --with-mpc=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-libmpc-1.3.1 --with-native-system-header-dir=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-glibc-2.38-44-dev/include --with-build-sysroot=/ --with-gxx-include-dir=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-gcc-13.2.0/include/c++/13.2.0/ --program-prefix= --enable-lto --disable-libstdcxx-pch --without-included-gettext --with-system-zlib --enable-static --enable-languages=c,c++ --disable-multilib --enable-plugin --disable-libcc1 --with-isl=/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-isl-0.20 --disable-bootstrap --build=x86_64-unknown-linux-gnu --host=x86_64-unknown-linux-gnu --target=x86_64-unknown-linux-gnu
Thread model: posix
Supported LTO compression algorithms: zlib
gcc version 13.2.0 (GCC) 
COMPILER_PATH=/nix/store/1rm6sr6ixxzipv5358x0cmaw8rs84g2j-glibc-2.38-44/lib/:/nix/store/agp6lqznayysqvqkx4k1ggr8n1rsyi8c-gcc-13.2.0-lib/lib/:/nix/store/kvlhk0gpm2iz1asbw1xjac2ch0r8kyw9-gcc-wrapper-13.2.0/bin/:/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/libexec/gcc/x86_64-unknown-linux-gnu/13.2.0/:/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/libexec/gcc/x86_64-unknown-linux-gnu/13.2.0/:/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/libexec/gcc/x86_64-unknown-linux-gnu/:/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/lib/gcc/x86_64-unknown-linux-gnu/13.2.0/:/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/lib/gcc/x86_64-unknown-linux-gnu/
LIBRARY_PATH=/nix/store/1rm6sr6ixxzipv5358x0cmaw8rs84g2j-glibc-2.38-44/lib/:/nix/store/agp6lqznayysqvqkx4k1ggr8n1rsyi8c-gcc-13.2.0-lib/lib/:/nix/store/kvlhk0gpm2iz1asbw1xjac2ch0r8kyw9-gcc-wrapper-13.2.0/bin/:/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/lib/gcc/x86_64-unknown-linux-gnu/13.2.0/:/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/lib/gcc/x86_64-unknown-linux-gnu/13.2.0/../../../../lib64/:/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/lib/gcc/x86_64-unknown-linux-gnu/13.2.0/../../../
COLLECT_GCC_OPTIONS='-z' 'noexecstack' '-o' '/work/hello' '-v' '-L/tmp/SVM-16553447527662537392' '-L/opt/oracle-graalvm-jdk21/lib/static/linux-amd64/glibc' '-L/opt/oracle-graalvm-jdk21/lib/svm/clibraries/linux-amd64' '-B' '/nix/store/1rm6sr6ixxzipv5358x0cmaw8rs84g2j-glibc-2.38-44/lib/' '-idirafter' '/nix/store/6jk1d1m5j9d8gjyq79zqlgqqs9j3gcwn-glibc-2.38-44-dev/include' '-idirafter' '/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/lib/gcc/x86_64-unknown-linux-gnu/13.2.0/include-fixed' '-B' '/nix/store/agp6lqznayysqvqkx4k1ggr8n1rsyi8c-gcc-13.2.0-lib/lib' '-B' '/nix/store/kvlhk0gpm2iz1asbw1xjac2ch0r8kyw9-gcc-wrapper-13.2.0/bin/' '-L/nix/store/1rm6sr6ixxzipv5358x0cmaw8rs84g2j-glibc-2.38-44/lib' '-L/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/lib/gcc/x86_64-unknown-linux-gnu/13.2.0' '-L/nix/store/agp6lqznayysqvqkx4k1ggr8n1rsyi8c-gcc-13.2.0-lib/lib' '-L/nix/store/agp6lqznayysqvqkx4k1ggr8n1rsyi8c-gcc-13.2.0-lib/lib' '-mtune=generic' '-march=x86-64' '-dumpdir' '/work/hello.'
 /nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/libexec/gcc/x86_64-unknown-linux-gnu/13.2.0/collect2 -plugin /nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/libexec/gcc/x86_64-unknown-linux-gnu/13.2.0/liblto_plugin.so -plugin-opt=/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/libexec/gcc/x86_64-unknown-linux-gnu/13.2.0/lto-wrapper -plugin-opt=-fresolution=/tmp/ccL4BMjM.res -plugin-opt=-pass-through=-lgcc -plugin-opt=-pass-through=-lgcc_s -plugin-opt=-pass-through=-lc -plugin-opt=-pass-through=-lgcc -plugin-opt=-pass-through=-lgcc_s --eh-frame-hdr -m elf_x86_64 -dynamic-linker /nix/store/1rm6sr6ixxzipv5358x0cmaw8rs84g2j-glibc-2.38-44/lib64/ld-linux-x86-64.so.2 -o /work/hello -z noexecstack /nix/store/1rm6sr6ixxzipv5358x0cmaw8rs84g2j-glibc-2.38-44/lib/crt1.o /nix/store/1rm6sr6ixxzipv5358x0cmaw8rs84g2j-glibc-2.38-44/lib/crti.o /nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/lib/gcc/x86_64-unknown-linux-gnu/13.2.0/crtbegin.o -L/tmp/SVM-16553447527662537392 -L/opt/oracle-graalvm-jdk21/lib/static/linux-amd64/glibc -L/opt/oracle-graalvm-jdk21/lib/svm/clibraries/linux-amd64 -L/nix/store/1rm6sr6ixxzipv5358x0cmaw8rs84g2j-glibc-2.38-44/lib -L/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/lib/gcc/x86_64-unknown-linux-gnu/13.2.0 -L/nix/store/agp6lqznayysqvqkx4k1ggr8n1rsyi8c-gcc-13.2.0-lib/lib -L/nix/store/agp6lqznayysqvqkx4k1ggr8n1rsyi8c-gcc-13.2.0-lib/lib -L/nix/store/1rm6sr6ixxzipv5358x0cmaw8rs84g2j-glibc-2.38-44/lib -L/nix/store/agp6lqznayysqvqkx4k1ggr8n1rsyi8c-gcc-13.2.0-lib/lib -L/nix/store/kvlhk0gpm2iz1asbw1xjac2ch0r8kyw9-gcc-wrapper-13.2.0/bin -L/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/lib/gcc/x86_64-unknown-linux-gnu/13.2.0 -L/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/lib/gcc/x86_64-unknown-linux-gnu/13.2.0/../../../../lib64 -L/nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/lib/gcc/x86_64-unknown-linux-gnu/13.2.0/../../.. -dynamic-linker=/nix/store/1rm6sr6ixxzipv5358x0cmaw8rs84g2j-glibc-2.38-44/lib/ld-linux-x86-64.so.2 --gc-sections --version-script /tmp/SVM-16553447527662537392/exported_symbols.list -x hello.o /opt/oracle-graalvm-jdk21/lib/svm/clibraries/linux-amd64/liblibchelper.a /opt/oracle-graalvm-jdk21/lib/static/linux-amd64/glibc/libnet.a /opt/oracle-graalvm-jdk21/lib/static/linux-amd64/glibc/libnio.a /opt/oracle-graalvm-jdk21/lib/static/linux-amd64/glibc/libjava.a /opt/oracle-graalvm-jdk21/lib/svm/clibraries/linux-amd64/libjvm.a --export-dynamic -lz -ldl -lpthread -lrt -lgcc --push-state --as-needed -lgcc_s --pop-state -lc -lgcc --push-state --as-needed -lgcc_s --pop-state /nix/store/rqga421d43q40blrrgmiw820p01a4nba-gcc-13.2.0/lib/gcc/x86_64-unknown-linux-gnu/13.2.0/crtend.o /nix/store/1rm6sr6ixxzipv5358x0cmaw8rs84g2j-glibc-2.38-44/lib/crtn.o
/nix/store/j2y057vz3i19yh4zjsan1s3q256q15rd-binutils-2.41/bin/ld: cannot find -lz: No such file or directory
collect2: error: ld returned 1 exit status

Please inspect the generated error report at:
/work/svm_err_b_20240326T121938.396_pid629.md

If you are unable to resolve this problem, please file an issue with the error report at:
https://graalvm.org/support
```

We can hack it by manually linking the missing library:

```
$ libdir=`dirname $(echo $PATH | tr : '\n' | grep gcc | tail -1)`/lib
$ chmod +w $libdir
$ ln -s /nix/store/*zlib*static/lib/* $libdir
$ native-image Hello
$ ./hello
Hello, World!
```