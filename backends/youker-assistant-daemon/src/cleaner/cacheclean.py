import os
from common import get_dir_size
from common import confirm_filesize_unit


class CacheClean():
    def __init__(self):
        pass

    def get_apt_cache(self):
        apt_cache = '/var/cache/apt/archives'
        #aptcachelist = map(lambda filename: '%s/%s<2_2>%s' % (apt_cache, filename, str(os.path.getsize('%s/%s' % (apt_cache, filename)))), filter(lambda filestr: filestr.endswith('deb'), os.listdir(apt_cache)))
        aptcachelist = ['%s/%s<2_2>%s' % (apt_cache,filename, confirm_filesize_unit(os.path.getsize('%s/%s' % (apt_cache, filename)))) for filename in os.listdir(apt_cache) if filename.endswith('deb')]
        return aptcachelist

    def get_softwarecenter_cache(self, homedir):
        centercachelist = []
        if homedir:
            softwarecenter_cache = '%s/.cache/software-center/' % homedir
        else:
            softwarecenter_cache = os.path.expanduser('~/.cache/software-center/')
        full_path = softwarecenter_cache
        if os.path.exists(full_path):
            for one in os.listdir(full_path):
                tmp_path = full_path + one
                if os.path.isdir(tmp_path):
                    size = get_dir_size(tmp_path)
                    centercachelist.append('%s<2_2>%s' % (tmp_path, confirm_filesize_unit(size)))
                else:
                    centercachelist.append('%s<2_2>%s' % (tmp_path, confirm_filesize_unit(os.path.getsize(tmp_path))))
        return centercachelist

if __name__ == "__main__":
    obja = CacheClean()
    obja.get_apt_cache()
    obja.get_softwarecenter_cache()
