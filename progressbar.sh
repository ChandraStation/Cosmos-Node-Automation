#The MIT License (MIT)

#Copyright (c) 2014 Hai Kieu

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

############################---Description---###################################
#                                                                              #
# Summary       : Show a progress bar GUI on terminal platform                 #
# Support       : haikieu2907@icloud.com                                        #
# Created date  : Aug 12,2014                                                  #
# Latest Modified date : Nov 20,2017                                           #
#                                                                              #
################################################################################

############################---Usage---#########################################

# Copy below functions (delay and progress fuctions) into your shell script directly
# Then invoke progress function to show progress bar 

# In other way, you could import source indirectly then using. Nothing different

################################################################################


#
# Description : delay executing script
#
function delay()
{
    sleep 0.2;
}

#
# Description : print out executing progress
# 
CURRENT_PROGRESS=0
function progress()
{
    PARAM_PROGRESS=$1;
    PARAM_PHASE=$2;

tput setaf 2;
    if [ $CURRENT_PROGRESS -le 0 -a $PARAM_PROGRESS -ge 0 ]  ; then echo -ne "░░░░░░░░░░░░░░░░░░░░ 0%  $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 5 -a $PARAM_PROGRESS -ge 5 ]  ; then echo -ne "█░░░░░░░░░░░░░░░░░░░ 5%  $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 10 -a $PARAM_PROGRESS -ge 10 ]; then echo -ne "██░░░░░░░░░░░░░░░░░░ 10% $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 15 -a $PARAM_PROGRESS -ge 15 ]; then echo -ne "███░░░░░░░░░░░░░░░░░ 15% $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 20 -a $PARAM_PROGRESS -ge 20 ]; then echo -ne "████░░░░░░░░░░░░░░░░ 20% $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 25 -a $PARAM_PROGRESS -ge 25 ]; then echo -ne "█████░░░░░░░░░░░░░░░ 25% $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 30 -a $PARAM_PROGRESS -ge 30 ]; then echo -ne "██████░░░░░░░░░░░░░░ 30% $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 35 -a $PARAM_PROGRESS -ge 35 ]; then echo -ne "███████░░░░░░░░░░░░░ 35% $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 40 -a $PARAM_PROGRESS -ge 40 ]; then echo -ne "████████░░░░░░░░░░░░ 40% $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 45 -a $PARAM_PROGRESS -ge 45 ]; then echo -ne "█████████░░░░░░░░░░░ 45% $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 50 -a $PARAM_PROGRESS -ge 50 ]; then echo -ne "██████████░░░░░░░░░░ 50% $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 55 -a $PARAM_PROGRESS -ge 55 ]; then echo -ne "███████████░░░░░░░░░ 55% $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 60 -a $PARAM_PROGRESS -ge 60 ]; then echo -ne "████████████░░░░░░░░ 60% $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 65 -a $PARAM_PROGRESS -ge 65 ]; then echo -ne "█████████████░░░░░░░ 65% $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 70 -a $PARAM_PROGRESS -ge 70 ]; then echo -ne "██████████████░░░░░░ 70% $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 75 -a $PARAM_PROGRESS -ge 75 ]; then echo -ne "███████████████░░░░░ 75% $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 80 -a $PARAM_PROGRESS -ge 80 ]; then echo -ne "████████████████░░░░ 80% $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 85 -a $PARAM_PROGRESS -ge 85 ]; then echo -ne "█████████████████░░░ 85% $PARAM_PHASE \r"  ; delay; fi;
    if [ $CURRENT_PROGRESS -le 90 -a $PARAM_PROGRESS -ge 90 ]; then echo -ne "██████████████████░░ 90% $PARAM_PHASE \r" ; delay; fi;
	if [ $CURRENT_PROGRESS -le 90 -a $PARAM_PROGRESS -ge 95 ]; then echo -ne "███████████████████░ 95% $PARAM_PHASE \r" ; delay; fi;
    if [ $CURRENT_PROGRESS -le 90 -a $PARAM_PROGRESS -ge 100 ]; then echo -ne "████████████████████ 100% $PARAM_PHASE \r" ; delay; fi;
    if [ $CURRENT_PROGRESS -le 100 -a $PARAM_PROGRESS -ge 100 ];then echo -ne 'Done!                                            \n' ; delay; fi;

    CURRENT_PROGRESS=$PARAM_PROGRESS;
tput sgr0
}

#################################### DEMO ######################################

# This is a simple demostration

# Important notice: below code is not necessary in your code, remember to remove before using

################################################################################

echo "The task is in progress, please wait a few seconds"

#Do some tasks
progress 10 "Phase 1      "
#Do some tasks
progress 20 "Phase 1      "
#Do some tasks
progress 40 "Phase 2      "
#Do some tasks
progress 60 "Processing..."
#Do some tasks
progress 80 "Processing..."
#Do some tasks
progress 90 "Processing..."
#Do some tasks
progress 100 "Done        "

echo