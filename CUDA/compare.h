#ifndef COMPARE_H__
#define COMPARE_H__

void compareImages(std::string reference_filename, std::string test_filename, 
                   bool useEpsCheck, double perPixelError, double globalError);

#endif