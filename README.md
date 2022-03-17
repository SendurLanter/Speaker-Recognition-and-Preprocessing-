# Speaker-Recognition-and-Preprocessing (EEC201 final project) - EL TIRADO

## Usage :
         - Simply download every file to the same directory and run the Main_test.m
         - The code contains the speaker recognition on the extended training and test sets (i.e. original users + our own voices )
         - To experiment with the notch filter ( Task 8 ), you can run the code notch_filter_data.m . You can change the filter width in
         line 85
         
## Link to the report:
 - Here is the link to the final report ( Overleaf viewer mode)
   [Report](https://www.overleaf.com/read/yzdypxtfcdwk)

## Datasets:
 - All the datasets use for the training and testing can be found under the Data directory
 - Original dataset - 11 users 1 training sample per user, 8 users 1 testing sample per user
 - Extended dataset 1 - Original dataset + 1 train and 1 test voice sample from us.
 - Extended dataset 2 - Original dataset + different words such as sorry, yes, and why in other languages. ( Japanese, Mandarin )

## Results:

### Overall performances - 
Attempt | #1 | #2 | #3 | #4 | #5 | #6 | #7 | #8 | #9 | #10 | #11
--- | --- | --- | --- |--- |--- |--- |--- |--- |--- |--- |---
Seconds | 301 | 283 | 290 | 286 | 289 | 285 | 287 | 287 | 272 | 276 | 269

