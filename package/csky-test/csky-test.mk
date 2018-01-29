#
##############################################################################
#
# csky arch
#
################################################################################

CSKY_TEST_VERSION = ce8b17e2aeeefb402c17231c53412473a5a6b5fb
CSKY_TEST_SITE = $(call github,riseandfall,csky-test,$(CSKY_TEST_VERSION))
ifeq ($(BR2_CSKY_TEST_GDB_FILE),)
CSKY_TEST_CP_GDBINIT =
else
CSKY_TEST_CP_GDBINIT = cp -f $(BR2_CSKY_TEST_GDB_FILE) $(BINARIES_DIR)/.gdbinit
endif

define CSKY_TEST_CONFIGURE_CMDS
echo CONFIG_CPU=$(BR2_CSKY_TEST_CPU) > $(@D)/config
echo CONFIG_LIBC=$(BR2_CSKY_TEST_LIBC) >> $(@D)/config
echo CONFIG_QEMU=$(BR2_CSKY_TEST_QEMU) >> $(@D)/config
echo CONFIG_GDB=$(BR2_CSKY_TEST_GDB_FILE) >> $(@D)/config
echo CONFIG_LTP=$(BR2_PACKAGE_CSKY_TEST_LTP) >> $(@D)/config
echo CONFIG_DHRYSTONE=$(BR2_PACKAGE_CSKY_TEST_DHRYSTONE) >> $(@D)/config
echo CONFIG_WHETSTONE=$(BR2_PACKAGE_CSKY_TEST_WHETSTONE) >> $(@D)/config
endef

define CSKY_TEST_BUILD_CMDS
make -C $(@D)
endef


define CSKY_TEST_INSTALL_TARGET_CMDS
mkdir -p $(HOST_DIR)/csky-test/
mkdir -p $(TARGET_DIR)/usr/lib/csky-test/
cp -f $(@D)/out/sh/* $(HOST_DIR)/csky-test/
cp -f $(@D)/out/configs/* $(TARGET_DIR)/usr/lib/csky-test/
cp -f $(@D)/out/S90test $(TARGET_DIR)/etc/init.d/
cp -f $(BR2_CSKY_TEST_GDB_FILE) $(BINARIES_DIR)/.gdbinit
$(CSKY_TEST_CP_GDBINIT)
endef

$(eval $(generic-package))
$(eval $(host-generic-package))