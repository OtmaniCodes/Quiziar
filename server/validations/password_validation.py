# a password is always 9 chars long, at least 1 symbol, 4 letters and 4 digits
class PasswordValidartor:

    def __init__(self) -> None:
        pass

    @property
    def password(self):
        return self.__password

    @password.setter
    def password(self, password):
        self.__password = password

    def is_password_valid(self):
        validation_error = ''
        try:
            if len(self.password) < 8:
                validation_error = 'password should be at least 8 characters long'
            elif self.password.count(' ') > 0:
                validation_error = 'no spaces allowed in your password.'
            else:
                symbols_count = len([i for i in self.password if not(i.isnumeric()) and not(i.isalpha())])
                letters_count = len([i for i in self.password if i.isalpha()])
                digits_count = len([i for i in self.password if i.isnumeric()])
                if symbols_count == 0:
                    validation_error = 'your password should include symbols like: @, %, &, $...'
                elif letters_count < 4:
                    validation_error = 'your password should include at least 4 letters.'
                elif digits_count < 4:
                    validation_error = 'your password should include at least 4 digits.'                
        except Exception as e:
            raise e
        if len(validation_error) == 0:
            return True
        else:
            raise ValueError(validation_error)