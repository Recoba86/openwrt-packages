include $(TOPDIR)/rules.mk

PKG_NAME:=dns-adaptive-routing
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/dns-adaptive-routing
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Adaptive DNS routing based on destination TCP latency
  DEPENDS:=+jq +netcat
endef

define Package/dns-adaptive-routing/description
  Dynamically checks latency for baseline domains and updates dnsmasq upstreams dynamically.
endef

define Build/Compile
	# Nothing to compile
endef

define Package/dns-adaptive-routing/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/init.d $(1)/etc/cron.d
	$(INSTALL_BIN) $(CURDIR)/files/usr/bin/route_probe.sh $(1)/usr/bin/
	$(INSTALL_BIN) $(CURDIR)/files/usr/bin/apply_dns_state.sh $(1)/usr/bin/
	$(INSTALL_BIN) $(CURDIR)/files/etc/init.d/dns-adaptive-routing $(1)/etc/init.d/
	$(INSTALL_DATA) $(CURDIR)/files/etc/cron.d/dns-adaptive-routing $(1)/etc/cron.d/
endef

$(eval $(call BuildPackage,dns-adaptive-routing))
