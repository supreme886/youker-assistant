#!/usr/bin/python
# -*- coding: utf-8 -*-
### BEGIN LICENSE
# Copyright (C) 2007-2011 Tualatrix Chou <tualatrix@gmail.com>
# Copyright (C) 2013 ~ 2014 National University of Defense Technology(NUDT) & Kylin Ltd
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranties of
# MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
# PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.
### END LICENSE

import dbus
import dbus.service
import logging
#import gtk
log = logging.getLogger("DbusProxy")

INTERFACE = 'com.ubuntukylin.youker'
UKPATH = '/'
SHOWED = False

#def youker_error_dialog(title, message):
#    dialog = gtk.MessageDialog(None,
#                               gtk.DIALOG_MODAL,
#                               type=gtk.MESSAGE_ERROR,
#                               buttons=gtk.BUTTONS_OK)
#    dialog.set_markup("<b>%s</b>" % title)
#    dialog.format_secondary_markup(message)
#    dialog.run()
#    dialog.destroy()

def show_message(*args):
    from dialogs import ErrorDialog
    title = 'Daemon start failed'
    message = ('Youker Assisant systemdaemon didn\'t start correctly.\n'
                'If you want to help developers debugging, try to run "<b>sudo /usr/lib/python2.7/dist-packages/youker-assistant-daemon/src/youkersystem-daemon</b>" in a terminal.')
    #youker_error_dialog(title, message)
    ErrorDialog(title=title, message=message).launch()

def nothing(*args):
    return None

class DbusProxy:
    try:
        __system_bus = dbus.SystemBus()
        __object = __system_bus.get_object(INTERFACE, UKPATH)
    except Exception, e:
        #log.error(e)
        __object = None

    def __getattr__(self, name):
        global SHOWED
        try:
            return self.__object.get_dbus_method(name, dbus_interface=self.INTERFACE)
        except Exception, e:
            #log.error(e)
            if not SHOWED:
                SHOWED = True
                return show_message
            else:
                return nothing

    def get_object(self):
        return self.__object

class AccessDeniedException(dbus.DBusException):
    '''This exception is raised when some operation is not permitted.'''

    _dbus_error_name = 'com.ubuntukylin.youker.AccessDeniedException'

def init_dbus(dbus_iface=INTERFACE, dbus_path=UKPATH):
    '''init dbus'''
    proxy = DbusProxy()
    return proxy

if __name__ == '__main__':
    print init_dbus()
