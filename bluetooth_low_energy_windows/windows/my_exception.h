#ifndef BLEW_MY_EXCEPTION_H_
#define BLEW_MY_EXCEPTION_H_

#include <exception>
#include <string>

namespace bluetooth_low_energy_windows {
    class MyException : public std::exception {
    public:
        MyException(const std::string& message)
            : message(message)
        {
        }

        const char* what() const noexcept override;
    private:
        std::string message;
    };

}

#endif