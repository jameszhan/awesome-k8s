java -Dfile.encoding=UTF8 \
    -Djline.terminal=none \
    -Dsbt.global.base=/private/var/folders/2z/r2ry6hjx1s95sfs9ld3g9mc80000gn/T/sbt-global-pluginstub \
    -Dsbt.log.noformat=true \
    -Xms512M -Xmx1024M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M \
    -classpath "/Users/james/Library/Application Support/JetBrains/IntelliJIdea2021.1/plugins/Scala/launcher/sbt-launch.jar" \
    xsbt.boot.Boot "project root" run


java -Dfile.encoding=UTF8 \
    -Djline.terminal=none \
    -Dsbt.global.base=/private/var/folders/2z/r2ry6hjx1s95sfs9ld3g9mc80000gn/T/sbt-global-pluginstub \
    -Dsbt.log.noformat=true \
    -Xms512M -Xmx1024M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M \
    -classpath /opt/local/sdkman/candidates/sbt/1.3.6/bin/sbt-launch.jar \
    xsbt.boot.Boot "project root" run


/Library/Java/JavaVirtualMachines/jdk-11.0.2.jdk/Contents/Home/bin/java -Dfile.encoding=UTF8 \
    -Djline.terminal=none \
    -Dsbt.global.base=/private/var/folders/2z/r2ry6hjx1s95sfs9ld3g9mc80000gn/T/sbt-global-pluginstub \
    -Dsbt.log.noformat=true \
    -Xms512M -Xmx1024M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M \
    -classpath /opt/local/sdkman/candidates/sbt/1.3.6/bin/sbt-launch.jar \
    xsbt.boot.Boot "project root" run


/Library/Java/JavaVirtualMachines/jdk1.8.0_201.jdk/Contents/Home/bin/java \
    -DESS_REDIS_PORT=30379 \
    -DESS_EVENT_DIR=/tmp/data \
    -DKAFKA_SERVERS=172.20.8.24330092 \
    -DESS_TEST_ONLY=on \
    -DESS_REDIS_IP=172.20.8.243 \
    -DESS_EVENT_BACKUP=off \
    -DESS_LL_PRODUCER=com.hairoutech.ess.actor.robot.kubot.mock.EssMockLlActor$CommandRoute \
    -Dsbt.log.noformat=true \
    -DMOCK_SCAN_RESULT=on \
    -Dfile.encoding=UTF8 \
    -Djline.terminal=none \
    -Dplay.debug.classpath=true \
    -Dsbt.global.base=/private/var/folders/2z/r2ry6hjx1s95sfs9ld3g9mc80000gn/T/sbt-global-pluginstub \
    -Dconfig.resource=conf/application.conf \
    -Xms512M -Xmx1024M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M \
    -classpath /opt/local/sdkman/candidates/sbt/1.3.6/bin/sbt-launch.jar \
    xsbt.boot.Boot "project ess-gateway" run


java -Xms512M -Xmx1024M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M \
    -DESS_REDIS_PORT=30379 \
    -DESS_EVENT_DIR=/tmp/data \
    -DKAFKA_SERVERS=172.20.8.243:30092 \
    -DESS_TEST_ONLY=on \
    -DESS_REDIS_IP=172.20.8.243 \
    -DESS_EVENT_BACKUP=off \
    -DESS_LL_PRODUCER='com.hairoutech.ess.actor.robot.kubot.mock.EssMockLlActor$CommandRoute' \
    -Dsbt.log.noformat=true \
    -DMOCK_SCAN_RESULT=on \
    -Dfile.encoding=UTF8 \
    -Djline.terminal=none \
    -Dplay.debug.classpath=true \
    -Dsbt.global.base=/private/var/folders/2z/r2ry6hjx1s95sfs9ld3g9mc80000gn/T/sbt-global-pluginstub \
    -Dconfig.resource=conf/application.conf \
    -classpath /opt/local/sdkman/candidates/sbt/1.3.6/bin/sbt-launch.jar \
    xsbt.boot.Boot "project root" run


/Library/Java/JavaVirtualMachines/jdk1.8.0_201.jdk/Contents/Home/bin/java \
    -Dfile.encoding=UTF8 \
    -Djline.terminal=none \
    -Dsbt.global.base=/private/var/folders/2z/r2ry6hjx1s95sfs9ld3g9mc80000gn/T/sbt-global-pluginstub \
    -Dsbt.log.noformat=true \
    -Xms512M -Xmx1024M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M \
    -classpath /opt/local/sdkman/candidates/sbt/1.3.6/bin/sbt-launch.jar \ 
    xsbt.boot.Boot "project ess-map" ~run
