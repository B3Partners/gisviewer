/*
 * Copyright (C) 2013 B3Partners B.V.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * Tabcomponent for Gisviewer
 *
 * @requires jQuery (> 1.3.2)
 * @requires commonfunctions.js
 *
 * @param object options
 * @returns {TabComponent}
 */
B3PGissuite.defineComponent('TabComponent', {

    'defaultOptions': {
        useClick: false,
        useHover: true,
        tabvakClassname: 'tabvak',
        defaultTab: null,
        direction: 'right',
        enabledTabs: []
    },

    constructor: function(options) {
        var me = this;
        me.options = jQuery.extend(me.defaultOptions, options);
        me.labelContainer = jQuery('#' + me.options.labelContainer);
        me.tabLabelContainer = me.labelContainer.find('ul');
        me.tabContainer = jQuery('#' + me.options.tabContainer);
        me.tabCollection = {};
        me.tabIds = [];
        me.activeTab = null;
        me.lteie8 = jQuery('html').hasClass('lt-ie9');
        me.cookiename = me.options.tabContainer + '_activetab';
        me.setupEnabledTabs();
        me.initTabComponent();
        var resizeTimer = null;
        jQuery(window).bind('resize', function() {
            if (resizeTimer) clearTimeout(resizeTimer);
            resizeTimer = setTimeout(function() {
                me.doResize();
            }, 100);
        });
        var listenerAttached = B3PGissuite.commons.attachTransitionListener(this.tabContainer[0], function() {
            me.initTabComponent();
        });
    },

    setupEnabledTabs: function() {
        var tabComponent = this,
            options;
        // Loop over enabled tabs
        for(var i in this.options.enabledTabs) {
            var tabid = this.options.enabledTabs[i];
            if(!B3PGissuite.config.tabbladen.hasOwnProperty(tabid)) {
                return;
            }

            // Get tabobj from tabbladen defs
            var tabobj = B3PGissuite.config.tabbladen[tabid];
            // If a class is defined, create class
            if(tabobj.hasOwnProperty('class')) {
                // Extend default options by options from tabbladen defs
                options = jQuery.extend({
                    tabid: tabid,
                    id: tabobj.contentid,
                    title: tabobj['name']
                }, tabobj['options'] || {});
                // Create the defined component
                var comp = B3PGissuite.createComponent(tabobj['class'], options);
                // Render the component to the tab
                comp.renderTab(tabComponent);
            // Else create a tab from existing content
            } else {
                // Set taboptions
                options = {
                    'contentid': tabobj.contentid,
                    'checkResize': true
                };
                // Create a tab
                tabComponent.createTab(tabid, tabobj['name'], options);
            }
        }
    },

    initTabComponent: function() {
        var me = this;
        // Using a setTimeout with 0 seconds ensures this is executed at the end
        // of the JS execution stack so rendering will be complete (http://stackoverflow.com/questions/779379/why-is-settimeoutfn-0-sometimes-useful)
        setTimeout(function() {
            me.resizeLabels();
            me.showInitialTab();
        }, 0);
    },

    createTab: function(tabid, label, options) {
        var tabObj = this.appendTab(this.createTabObject(tabid, label, options), options);
        if(options) {
            if(options.hasOwnProperty('contentid')) {
                var contentcontainer = jQuery('#' + options.contentid);
                tabObj.container.html(contentcontainer.html());
                if(contentcontainer.hasClass('tabvak_with_iframe')) {
                    if(this.lteie8) {
                        tabObj.container.find("iframe").each(function() {
                            this.allowTransparency = 'allowtransparency';
                        });
                    }
                    tabObj.container.removeClass('tabvak').addClass('tabvak_with_iframe');
                }
                contentcontainer.remove();
            }
            if(options.hasOwnProperty('checkResize')) {
                if(tabObj.container.find('.tabvak_groot').length !== 0) {
                    tabObj.resizableContent = true;
                    this.resizeTabContents(tabid);
                }
            }
        }
        return tabObj.container.attr('id');
    },

    createTabObject: function(tabid, label, options) {
        return {
            'id': tabid,
            'label': this.createLabel(tabid, label),
            'container': this.createTabContainer(tabid, options),
            'resizableContent': options.resizableContent || false
        };
    },

    createTabContainer: function(tabid, options) {
        var tab = jQuery('<div></div>').css({'display': 'none'}).addClass(options.tabvakClassname || this.options.tabvakClassname).attr('id', tabid);
        return tab;
    },

    createLabel: function(tabid, labeltxt) {
        var me = this;
        var label = jQuery('<li></li>');

        label
            .bind('click', function(e) {
                me.handleTabClick(tabid, e);
            })
            .bind('mouseover', function(e) {
                me.handleTabHover(tabid, e);
            })
            .append('<a href="#">' + labeltxt + '</a>');

        return label;
    },

    appendTab: function(tabObj, options) {
        if(options && options.hasOwnProperty('containerid')) {
            $j("#" + options.containerid).append(tabObj.container.show());
            return tabObj;
        } else {
            this.tabIds.push(tabObj.id);
            this.tabCollection[tabObj.id] = tabObj;
            this.tabLabelContainer.append(tabObj.label);
            this.tabContainer.append(tabObj.container);
            this.resizeLabels();
            return this.tabCollection[tabObj.id];
        }
    },

    resizeLabels: function() {
        var noOfTabs = this.getTabCount();
        var totalWidth = this.tabContainer.width();
        var tabWidth = totalWidth;
        if(noOfTabs > 1) {
            tabWidth = Math.floor((totalWidth - (noOfTabs-1)) / noOfTabs) - (noOfTabs === 1 ? 0 : 1);
        }
        this.tabLabelContainer.find('a').width(tabWidth);
    },

    handleTabClick: function(tabid, e) {
        e.preventDefault();
        if(!this.options.useClick) return;
        this.setActive(tabid);
    },

    handleTabHover: function(tabid, e) {
        e.preventDefault();
        if(!this.options.useHover) return;
        this.setActive(tabid);
    },

    setVisible: function(tabid) {
        var currentTab = this.getActiveTab();
        if(currentTab !== null) {
            currentTab.container.hide();
            currentTab.label.removeClass('activelink');
        }
        var tabObj = this.getTab(tabid);
        if(tabObj !== null) {
            tabObj.container.show();
            tabObj.label.addClass('activelink');
            if(tabObj.resizableContent) {
                this.resizeTabContents(tabid);
            }
        }
    },

    showInitialTab: function() {
        if(this.tabCollection.length === 0) {
            return;
        }
        var activeTab = (B3PGissuite.config.useCookies ? B3PGissuite.commons.readCookie(this.cookiename) : null);
        if (activeTab !== null) {
            this.setActive(activeTab);
        } else if (B3PGissuite.config.user.demogebruiker) {
            this.setActive('themas'); // read default tab from config ?
        } else {
            if(this.options.defaultTab === null || !this.hasTab(this.options.defaultTab)) {
                this.options.defaultTab = this.tabIds[0];
            }
            this.setActive(this.options.defaultTab);
        }
    },

    setActive: function(tabid) {
        if(!this.hasTab(tabid)) return;
        this.setVisible(tabid);
        this.activeTab = tabid;
        if(B3PGissuite.config.useCookies) {
            B3PGissuite.commons.eraseCookie(this.cookiename);
            B3PGissuite.commons.createCookie(this.cookiename, tabid, '7');
        }
    },

    getActiveTab: function() {
        return this.activeTab === null ? null : this.getTab(this.activeTab);
    },

    hasTab: function(tabid) {
        return this.tabCollection.hasOwnProperty(tabid);
    },

    getTab: function(tabid) {
        if(!this.tabCollection.hasOwnProperty(tabid)) return null;
        return this.tabCollection[tabid];
    },

    doResize: function() {
        var tabid;
        for (tabid in this.tabCollection) {
            if(this.tabCollection.hasOwnProperty(tabid) && this.tabCollection[tabid].resizableContent) {
                this.resizeTabContents(tabid);
            }
        }
    },

    resizeTabContents: function(tabid) {
        var tabObj = this.tabCollection[tabid];
        var tabContainer = tabObj.container;
        var contentHeight = 0;
        var tabChilds = tabContainer.children().not('.tabvak_groot');
        if(tabChilds.length === 1 && tabChilds.is('form')) {
            tabChilds = tabChilds.children().not('.tabvak_groot');
        }
        tabChilds.each(function() {
            contentHeight += jQuery(this).outerHeight(true);
        });
        var elementHeight = (this.getTabHeight() - 30) - contentHeight;
        if(elementHeight > 0) {
            tabContainer.find('.tabvak_groot').height(elementHeight);
        }
    },

    getTabCount: function() {
        return this.tabIds.length;
    },

    getTabHeight: function() {
        return this.tabContainer.height();
    },

    getTabWidth: function() {
        return this.tabWidth;
    },

    isHidden: function() {
        return (
            (this.options.direction === 'left' && $j('#content_viewer').hasClass('tablinks_dicht')) ||
            (this.options.direction === 'right' && $j('#content_viewer').hasClass('tabrechts_dicht'))
        );
    },

    isOnlyTab: function(tabid) {
        return (this.options.enabledTabs.length === 1 && this.hasTab(tabid));
    },

    changeTabTitle: function(id, labeltxt) {
        var tabObj = this.getTab(id);
        if(tabObj) {
            tabObj.label.find('a').html(labeltxt);
        }
    },

    toggleTab: function() {
        B3PGissuite.get('Layout').panelResize(this.options.direction);
        this.resizeLabels();
    },

    getDirection: function() {
        return this.options.direction;
    }

});