#ifndef CORE_DOUBLE_UTILS_H
#define CORE_DOUBLE_UTILS_H

#include <cmath>
#include <cstdlib>
#include <iostream>

#define TOL 1e-6

inline bool equal(double x, double y){
    return std::abs(x - y) <= TOL;
}

inline bool not_equal(double x, double y){
    return std::abs(x - y) > TOL;
}

inline bool greater(double x, double y){
    if(std::abs(x) == INFINITY || std::abs(y) == INFINITY){
        return x > y;
    }
    else{
        return std::abs(x - y) > TOL && x > y;
    }
}

inline bool less(double x, double y){
    if(std::abs(x) == INFINITY || std::abs(y) == INFINITY){
        return x < y;
    }
    else{
        return std::abs(x - y) > TOL && x < y;
    }
}

class DoubleComparatorLess : public std::binary_function<double,double,bool>
{
public:
    bool operator()( const double &left, const double &right  ) const
    {
        return less(left, right);
    }
};

#endif //CORE_DOUBLE_UTILS_H