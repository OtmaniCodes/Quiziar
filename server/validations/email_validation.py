import re


class EmailValidartor:

    def __init__(self) -> None:
        pass

    @property
    def email(self):
        return self.__email

    @email.setter
    def email(self, email):
        self.__email = email

    def is_email_valid(self):
        validation_error = ''
        try:
            if len(self.email) == 0:
                validation_error = 'an email should be given'
            else:
                pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'
                match = re.match(pattern, self.email)
                if match is None:
                    validation_error = 'email is invalid'
        except Exception as e:
            raise e
        if len(validation_error) == 0:
            return True
        else:
            raise ValueError(validation_error)
