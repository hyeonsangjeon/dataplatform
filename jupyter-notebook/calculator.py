from IPython.lib import passwd
import fire

class Calculator(object):
    """jupyter notebook hash password creator"""

    def hash(self, pw):
        result = passwd(str(pw), "sha1")
        return result

if __name__ == "__main__":
    fire.Fire(Calculator)