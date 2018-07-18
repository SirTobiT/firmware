# site.mk for Freifunk Duesseldorf-Flingern

# for feature packs see https://github.com/freifunk-gluon/gluon/blob/v2018.1.x/package/features
GLUON_FEATURES := \
	web-wizard \
	web-advanced \
	mesh-batman-adv-15 \
	respondd \
	autoupdater \
	ebtables \
	ebtables-limit-arp \
	radv-filterd \
	ebtables-filter-multicast \
	ebtables-filter-ra-dhcp \
	ebtables-source-filter \
	mesh-vpn-tunneldigger \
	tunneldigger-watchdog \
	radvd \
	status-page

# eulenfunk:
GLUON_SITE_PACKAGES := \
	gluon-weeklyreboot \
	gluon-hotfix \
	gluon-quickfix \
	gluon-txpowerfix \
	gluon-banner \
	gluon-linkcheck \
	gluon-ssid-changer


# PROBLEM:
# ev. macht dieses paket:
# - ffho-ath9k-blackout-workaround
# das selbe wie diese beiden zusammen:
# - gluon-hotfix 
# - gluon-quickfix

# ffho not working, see https://github.com/FreifunkHochstift/ffho-packages/pull/8
#GLUON_SITE_PACKAGES += \
#	ffho-ath9k-blackout-workaround

# ffffm 
# ev. kann man ffffm-additional-wifi-json-info teilweise durch standard gluon respondd-module-airtime ersetzen
GLUON_SITE_PACKAGES += \
	ffffm-keep-radio-channel \
	ffffm-additional-wifi-json-info

# ffki:
GLUON_SITE_PACKAGES += \
	gluon-config-mode-ppa

# ffrl:
GLUON_SITE_PACKAGES += \
	gluon-tunneldigger-watchdog


# openwrt:
GLUON_SITE_PACKAGES += \
	haveged \
	iptables \
	iwinfo \
	socat

DEFAULT_GLUON_RELEASE := SBRANCH

# Allow overriding the release number from the command line
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)

GLUON_PRIORITY ?= 0
GLUON_LANGS ?= de en 
GLUON_REGION ?= eu
GLUON_ATH10K_MESH ?= 11s
