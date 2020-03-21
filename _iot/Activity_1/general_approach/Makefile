COMPONENT=RadioIdToLedsAppC
#BUILD_EXTRA_DEPS = RadioCountMsg.py RadioCountMsg.class
#CLEAN_EXTRA = RadioCountMsg.py RadioCountMsg.class RadioCountMsg.java

#RadioCountMsg.py: RadioIdToLeds.h
#	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=RadioCountMsg RadioIdToLeds.h radio_count_msg -o $@

#RadioCountMsg.class: RadioCountMsg.java
#	javac RadioCountMsg.java

#RadioCountMsg.java: RadioIdToLeds.h
#	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=RadioCountMsg RadioIdToLeds.h radio_count_msg -o $@

CFLAGS += -I$(TOSDIR)/lib/printf
#CFLAGS += -DNEW_PRINTF_SEMANTICS





include $(MAKERULES)


