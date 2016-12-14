# SeizurePrediction
Readme.md


Website: 
Our website can be reached at https://seizureprediciton.firebaseapp.com, after goes to our website, you can create your own account. Please note that the password should be at least 8 characters long and also a combination of numbers and letters.
After login, you will go to our main page. Explore everything there! All the files for website are in the folder "public". You can view our CSS, HTML and javascript code in this folder.

Notes: 

1) You can see our login, signup, and main page in folder "pubic", their javascrip is in public/js/AdminLTE folder.
2) EEG chart page, mailbox page, calendar page is in folder "Pages". Their JS is in the bottom of these pages and also public/pages/js folder.


MATLAB:

Notes: 

- The Wavelet Toolbox and the Statistics and Machine Learning Toolbox are needed in order to run this program

- The program was not designed to check errors for incorrect user inputs. If an invalid value is typed in, the program will fail and exit

1) Download the data from: https://www.kaggle.com/c/melbourne-university-seizure-prediction/data
2) Load the data, EEG_SVM.m, eeg_read_svm.m, feature_matrix.m into the current path for MATLAB
3) Run EEG_SVM:
  A) Type the patient number (1, 2 or 3)
  B) Type the number of trials to run (minimum number: 2)
  C) Type 1 for Training, 2 for Testing *A training trial MUST be run before a testing trial, otherwise an error will occur and the program will fail
4) Define the weboptions:
  myOptions = weboptions(‘ContentType’, ‘json', ‘MediaType', 'application/json', ‘RequestMethod', 'post', ‘ArrayFormat’, ‘json');
5) Type: 
  response = webwrite('https://seizureprediciton.firebaseio.com/FILELABEL.json', TestLabel, myOptions);
  
  *Note: restrict the amount of data that is uploaded to approximately 100 samples, since the website has difficulty displaying too much data and will become unresponsive
