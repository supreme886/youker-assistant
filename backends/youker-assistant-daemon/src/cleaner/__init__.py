#!/usr/bin/python
# -*- coding: utf-8 -*-
### BEGIN LICENSE
# Copyright (C) 2013 National University of Defense Technology(NUDT) & Kylin Ltd
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

import os
import sys
import apt
import apt_pkg
import shutil
import commands
from apt.progress.base import InstallProgress


import historyclean
import cookiesclean
import searchsame
import diskanalyse
import osslim
import common
import cacheclean
import oldkernel
import systemhistory
import dashhistory

HOMEDIR = ''

def get_user_homedir(homedir):
    global HOMEDIR
    HOMEDIR = homedir

def return_homedir_sysdaemon():
    global HOMEDIR
    return HOMEDIR

# clean up by one key
class OneKeyClean():
    def __init__(self):
        self.objunneed = CleanTheUnneed()
        self.objcache = CleanTheCache()

    def get_onekey_crufts(self, sesobj, mode_list):
        homedir = common.return_homedir_sesdaemon()
        crufts_dic = {}
        total_dic = {}
        flag_dic = {'history': False, 'cookies': False, 'cache': False}
        for mode in mode_list:
            flag_dic['%s' % mode] = True

        if flag_dic['history']:
            historysize = 0
            objhg = historyclean.HistoryClean(homedir)
            filepathf = common.analytical_profiles_file(homedir) + 'places.sqlite'
            if os.path.exists(filepathf):
                tempf_list = objhg.scan_firefox_history_records(filepathf)
                for onef in tempf_list:
                    sesobj.display_scan_process(onef[1])
                    #sesobj.display_scan_process_msg(onef[1])
                    historysize += onef[2]
            filepathc = "%s/.config/chromium/Default/History" % homedir
            if os.path.exists(filepathc):
                run = common.process_pid("chromium-browser")
                if not run:
                    tempc_list = objhg.scan_chromium_history_records(filepathc)
                    for onec in tempc_list:
                        sesobj.display_scan_process(onec[1])
                        #sesobj.display_scan_process_msg(onec[1])
                        historysize += onec[2]
            total_dic['history'] = str(historysize)
        if flag_dic['cookies']:
            cookiessize = 0
            objcg = cookiesclean.CookiesClean(homedir)
            filepathff = common.analytical_profiles_file(homedir) + "cookies.sqlite"
            if os.path.exists(filepathff):
                pamf = [filepathff, 'moz_cookies', 'baseDomain']
                tempff_list = objcg.scan_cookies_records(pamf[0], pamf[1], pamf[2])
                for oneff in tempff_list:
                    sesobj.display_scan_process(oneff[0])
                    #sesobj.display_scan_process_msg(oneff[0])
                    cookiessize += oneff[1]
            filepathcc = "%s/.config/chromium/Default/Cookies" % homedir
            if os.path.exists(filepathcc):
                pamc = [filepathcc, 'cookies', 'host_key']
                tempcc_list = objcg.scan_cookies_records(pamc[0], pamc[1], pamc[2])
                for onecc in tempcc_list:
                    sesobj.display_scan_process(onecc[0])
                    #sesobj.display_scan_process_msg(onecc[0])
                    cookiessize += onecc[1]
            total_dic['cookies'] = str(cookiessize)
        if flag_dic['cache']:
            cachesize = 0
            objcache = cacheclean.CacheClean()
            apt_path = "/var/cache/apt/archives"
            temp_apt_list = objcache.scan_apt_cache(apt_path)
            for oneapt in temp_apt_list:
                sesobj.display_scan_process(oneapt)
                #sesobj.display_scan_process_msg(oneapt)
                cachesize += os.path.getsize(oneapt)
            swcenterpath = '%s/.cache/software-center' % homedir
            temp_swcenter_list = objcache.public_scan_cache(swcenterpath)
            for oneswcenter in temp_swcenter_list:
                sesobj.display_scan_process(oneswcenter)
                #sesobj.display_scan_process_msg(oneswcenter)
                if os.path.isdir(oneswcenter):
                    cachesize += common.get_dir_size(oneswcenter)
                else:
                    cachesize += os.path.getsize(oneswcenter)
            total_dic['cache'] = common.confirm_filesize_unit(cachesize)
        return total_dic

    def get_scan_result(self, mode_list):
        global HOMEDIR
        result_dic = {}
        flag_dic = {'history': False, 'cookies': False, 'cache': False}
        for mode in mode_list:
            flag_dic['%s' % mode] = True
        ### the part of history
        if flag_dic['history']:
            history_list = []
            objhistory = CleanTheHistory(None)
            tmp_history_list = objhistory.get_scan_result(HOMEDIR)
            #tmp_history_str = '<1_1>'.join(tmp_history_list)
            for record in tmp_history_list:
                resulthistory = record.split('<2_2>')[0]
                history_list.append(resulthistory)
            result_dic['history'] = history_list
            result_dic['historydata'] = str(len(history_list))
            del objhistory

        ### the part of cookies
        if flag_dic['cookies']:
            cookies_list = []
            cookiesdata = 0
            objcookies = CleanTheCookies(None)
            tmp_cookies_list = objcookies.get_scan_result(HOMEDIR)
            for record in tmp_cookies_list:
                resultcookies = record.split('<2_2>')[0]
                cookiesdata += int(record.split('<2_2>')[1])
                cookies_list.append(resultcookies)
            #tmp_cookies_str = '<1_1>'.join(tmp_cookies_list)
            result_dic['cookies'] = cookies_list
            result_dic['cookiesdata'] = str(cookiesdata)
            del objcookies

        ### the part of cache
        if flag_dic['cache']:
            cache_list = []
            cachedata = 0
            tmp_cache_dic = self.objcache.get_scan_result(HOMEDIR)
            for k in tmp_cache_dic:
                if tmp_cache_dic[k]:
                    tmp_cache_list = tmp_cache_dic[k].split('<1_1>')
                    for one in tmp_cache_list:
                        resultcache = one.split('<2_2>')[0]
                        cache_list.append(resultcache)
            result_dic['cache'] = cache_list
            if cache_list:
                for one in cache_list:
                    size = 0
                    if os.path.isdir(one):
                        size = common.get_dir_size(one)
                    else:
                        size = os.path.getsize(one)
                    cachedata += size
            result_dic['cachedata'] = common.confirm_filesize_unit(cachedata)
        return result_dic


# the functions of search the same files
class SearchTheSame():
    def __init__(self):
        self.objs = searchsame.SearchSame()

    def get_scan_result(self, path):
        self.path = path
        self.objs.search_by_style(self.path)
        samefile_list = self.objs.adjust_the_dic()
        return samefile_list

# the functions of manage the large files
class ManageTheLarge():
    def __init__(self):
        self.objl = diskanalyse.DiskAnalyse()

    def get_scan_result(self, size, path):
        self.path = path
        finalsize = size * 1024 * 1024
        #self.objl.hundred_large_files(finalsize, self.path)
        #self.objl.type_of_file()
        largefile_dic = self.objl.adjust_the_list(finalsize, self.path)
        return largefile_dic
        
# the functions of clean the browser history
class CleanTheHistory():
    def __init__(self, systemdaemon):
        self.sysdaemon = systemdaemon

    def get_scan_result(self, homedir = ''):
        objhg = historyclean.HistoryClean(homedir)
        idurlcount = objhg.scan_the_records()
        return idurlcount

    def get_history_crufts(self, flag):
        homedir = common.return_homedir_sesdaemon()
        objhg = historyclean.HistoryClean(homedir)
        crufts_list = []
        judge_list = []

        if flag in "firefox":
            filepathf = common.analytical_profiles_file(homedir) + 'places.sqlite'
            if os.path.exists(filepathf):
                temp_list = objhg.scan_firefox_history_records(filepathf)
                crufts_list = ["%s<2_2>%s<2_2>%s" % (str(each[0]), each[1], str(each[2])) for each in temp_list]
            else:
                judge_list.append('No')
                return judge_list
        if flag in "chromium":
            filepathc = "%s/.config/chromium/Default/History" % homedir
            if os.path.exists(filepathc):
                run = common.process_pid("chromium-browser")
                if not run:
                    temp_list = objhg.scan_chromium_history_records(filepathc)
                    crufts_list = ["%s<2_2>%s<2_2>%s" % (str(each[0]), each[1], str(each[2])) for each in temp_list]
                else:
                    judge_list.apend('True')
                    return judge_list
            else:
                judge_list.append('No')
                return judge_list
        return crufts_list

    def clean_all_history_crufts(self, flag):
        homedir = return_homedir_sysdaemon()
        objca = historyclean.HistoryClean(homedir)
        running = False

        if flag in "firefox":
            filepathf = common.analytical_profiles_file(homedir) + 'places.sqlite'
            objca.clean_firefox_all_records(filepathf)
        if flag in "chromium":
            run = common.process_pid("chromium-browser")
            if not run:
                filepathc = "%s/.config/chromium/Default/History" % homedir
                objca.clean_chromium_all_records(filepathc)
            else:
                running = True
        return running

    def clean_the_cruftlist(self):
        global HOMEDIR
        objhc = historyclean.HistoryClean(HOMEDIR)
        objhc.clean_all_records()

    def clean_the_cruftlist_for_main(self, historynum):
        global HOMEDIR
        objhc = historyclean.HistoryClean(HOMEDIR)
        objhc.clean_all_records()
        self.sysdaemon.clean_process_main_msg('%s records has been delete' % historynum)

    def clean_the_cruftlist_for_second(self, historynum):
        global HOMEDIR
        objhc = historyclean.HistoryClean(HOMEDIR)
        objhc.clean_all_records()
        self.sysdaemon.clean_process_second_msg('%s records has been delete' % historynum)

# the function of clean the system history
class CleanSystemHistory():
    def get_scan_result(self, homedir = ''):
        objhg = systemhistory.SystemHistory()
        url = objhg.scan_the_xml(homedir)
        return url

    def clean_the_cruftlist(self):
        global HOMEDIR
        objhc = systemhistory.SystemHistory()
        objhc.clean_the_xml(HOMEDIR)


# the function of clean the dash history
class CleanDashHistory():
    def get_scan_result(self, homedir = ''):
        objhg = dashhistory.DashHistory(homedir)
        num = objhg.scan_the_records()
        return num

    def clean_the_cruftlist(self):
        global HOMEDIR
        objhc = dashhistory.DashHistory(HOMEDIR)
        objhc.clean_the_records()

# the function of clean the cookies
class CleanTheCookies():
    def __init__(self, daemon_obj):
        self.daemon_obj = daemon_obj

    def get_scan_result(self, homedir = ''):
        objcg = cookiesclean.CookiesClean(homedir)
        domaincount = objcg.scan_the_records()
        return domaincount

    def get_cookies_crufts(self, flag):
        homedir = common.return_homedir_sesdaemon()
        objcg = cookiesclean.CookiesClean(homedir)
        crufts_list = []

        if flag in "firefox":
            filepathf = common.analytical_profiles_file(homedir) + "cookies.sqlite"
            if os.path.exists(filepathf):
                #self.daemon_obj.deb_exists_firefox("yes")
                pamf = [filepathf, 'moz_cookies', 'baseDomain']
                temp_list = objcg.scan_cookies_records(pamf[0], pamf[1], pamf[2])
                crufts_list = ["%s<2_2>%s" % (eachone[0], str(eachone[-1])) for eachone in temp_list]
            else:
                #self.daemon_obj.deb_exists_firefox("no")
                crufts_list.append('None')
                return crufts_list
        if flag in "chromium":
            filepathc = "%s/.config/chromium/Default/Cookies" % homedir
            if os.path.exists(filepathc):
                #self.daemon_obj.deb_exists_chromium("yes")
                pamc = [filepathc, 'cookies', 'host_key']
                temp_list = objcg.scan_cookies_records(pamc[0], pamc[1], pamc[2])
                crufts_list = ["%s<2_2>%s" % (eachone[0], str(eachone[-1])) for eachone in temp_list]
            else:
                #self.daemon_obj.deb_exists_chromium("no")
                crufts_list.append('None')
                return crufts_list

        return crufts_list

    def clean_one_cookies_cruft(self, flag, domain):
        homedir = return_homedir_sysdaemon()
        objcc = cookiesclean.CookiesClean(homedir)

        if flag in "firefox":
            filepathf = common.analytical_profiles_file(homedir) + "cookies.sqlite"
            pamf = [filepathf, 'moz_cookies', 'baseDomain', domain]
            objcc.clean_cookies_record(pamf[0], pamf[1], pamf[2], pamf[3])
        if flag in "chromium":
            filepathc = "%s/.config/chromium/Default/Cookies" % homedir
            pamc = [filepathc, 'cookies', 'host_key', domain]
            objcc.clean_cookies_record(pamc[0], pamc[1], pamc[2], pamc[3])
            
    def clean_all_cookies_crufts(self, flag):
        homedir = return_homedir_sysdaemon()
        objcc = cookiesclean.CookiesClean(homedir)

        if flag in "firefox":
            filepathf = common.analytical_profiles_file(homedir) + "cookies.sqlite"
            pamf = [filepathf, 'moz_cookies', 'baseDomain']
            objcc.clean_all_records(pamf[0], pamf[1], pamf[2])
        if flag in "chromium":
            filepathc = "%s/.config/chromium/Default/Cookies" % homedir
            pamc = [filepathc, 'cookies', 'host_key']
            objcc.clean_all_records(pamc[0], pamc[1], pamc[2])
            
    def clean_the_cruftlist_for_main(self, cruftlist):
        global HOMEDIR
        flag = None
        objcc = cookiesclean.CookiesClean(HOMEDIR)
        for cruft in cruftlist:
            #self.sysdaemon.clean_process_main_msg("cleaning %s's cookies" % cruft)
            flag = objcc.clean_the_records(cruft)

    def clean_the_cruftlist_for_second(self, cruftlist):
        global HOMEDIR
        flag = None
        objcc = cookiesclean.CookiesClean(HOMEDIR)
        for cruft in cruftlist:
            #self.sysdaemon.clean_process_second_msg("cleaning %s's cookies" % cruft)
            flag = objcc.clean_the_records(cruft)

    def clean_the_cruftlist(self, cruftlist):
        global HOMEDIR
        flag = None
        objcc = cookiesclean.CookiesClean(HOMEDIR)
        for cruft in cruftlist:
            flag = objcc.clean_the_records(cruft)

# the function of scan the unneedpackages
class CleanTheUnneed():
    def __init__(self):
        self.objc = osslim.OsSlim()

    def get_scan_result(self):
        namesummarysize = self.objc.get_spare_packages()
        return namesummarysize

# the function of clean old kernel
class CleanTheOldkernel():
    def __init__(self):
        self.objc = oldkernel.OldKernel()

    def get_scan_result(self):
        namesize = self.objc.get_old_kernel()
        return namesize

# the function of scan the cache
class CleanTheCache():
    def __init__(self):
        self.objc = cacheclean.CacheClean()

    def get_scan_result(self, homedir = ''):
        result_dic = {}
        tmp_apt_str = '<1_1>'.join(self.objc.get_apt_cache())
        tmp_center_str = '<1_1>'.join(self.objc.get_softwarecenter_cache(homedir))
        result_dic['apt'] = tmp_apt_str
        result_dic['softwarecenter'] = tmp_center_str
        return result_dic

    def get_cache_crufts(self):
        result_dic = {}
        apt_path = '/var/cache/apt/archives'
        temp_apt_list = self.objc.scan_apt_cache(apt_path)
        apt_and_size = ['%s<2_2>%s' % (filepath, common.confirm_filesize_unit(os.path.getsize(filepath))) for filepath in temp_apt_list]
        result_dic['apt'] = '<1_1>'.join(apt_and_size)

        homedir = common.return_homedir_sesdaemon()
        swcenterpath = '%s/.cache/software-center' % homedir
        temp_swcenter_list = self.objc.public_scan_cache(swcenterpath)
        swcenter_and_size = []
        for line in temp_swcenter_list:
            if os.path.isdir(line):
                swcenter_and_size.append('%s<2_2>%s' % (line, common.confirm_filesize_unit(common.get_dir_size(line))))
            else:
                swcenter_and_size.append('%s<2_2>%s' % (line, common.confirm_filesize_unit(os.path.getsize(line))))
        result_dic['softwarecenter'] = '<1_1>'.join(swcenter_and_size)

        return result_dic

# the function of clean cruft files and cruft packages
class FunctionOfClean():
    def __init__(self, systemdaemon):
        self.sysdaemon = systemdaemon

    def clean_the_file_for_main(self, cruftlist):
        for cruft in cruftlist:
            tmp = cruft.encode("UTF-8")
            self.sysdaemon.clean_process_main_msg("cleaning %s" % tmp)
            if tmp:
                if os.path.isdir(tmp):
                    shutil.rmtree(tmp)
                else:
                    os.remove(tmp)

    def clean_the_file_for_second(self, cruftlist):
        for cruft in cruftlist:
            tmp = cruft.encode("UTF-8")
            self.sysdaemon.clean_process_second_msg("cleaning %s" % tmp)
            if tmp:
                if os.path.isdir(tmp):
                    shutil.rmtree(tmp)
                else:
                    os.remove(tmp)

    def clean_the_file(self, cruftlist):
        for cruft in cruftlist:
            tmp = cruft.encode("UTF-8")
            if tmp:
                if os.path.isdir(tmp):
                    shutil.rmtree(tmp)
                else:
                    os.remove(tmp)

    def clean_the_package(self, cruftlist):
        if cruftlist:
            cache = common.get_cache_list()
            cache.open()
            for cruft in cruftlist:
                pkg = cache[cruft]
                if pkg.is_installed:
                    pkg.mark_delete()
            cache.commit(None, MyInstallProgress())

class MyInstallProgress(InstallProgress):
        def __init__(self):
            InstallProgress.__init__(self)

        def statusChange(self, pkg, percent, status):
            pass

        def error(self, errorstr):
            pass

