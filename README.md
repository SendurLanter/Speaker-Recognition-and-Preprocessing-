# Speaker-Recognition-and-Preprocessing (EEC201 final project) - EL TIRADO

## Usage :
         - Simply download every file to the same directory and run the Main_test.m
         - The code contains the speaker recognition on the extended training and test sets (i.e. original users + our own voices )
         - To experiment with the notch filter ( Task 8 ), you can run the code notch_filter_data.m . You can change the filter width in
         line 85
         
## Link to the report:
 - Report in the repo named Final_Report.pdf.pdf or download from [Overleaf](https://www.overleaf.com/read/yzdypxtfcdwk)
 - Presentation slide in the repo named Presentation.pptx or download from [Google Slide](https://docs.google.com/presentation/d/1_XmiSBVHOXC19QRkCU1uiK0fqnVT0Il3/edit?usp=sharing&ouid=116751163679535791293&rtpof=true&sd=true)
 - Here is the link for presentation video [Google Drive](https://drive.google.com/file/d/117qruDk5RExCeeEFHU1y7OrQVyKmrgAH/view?usp=sharing)

## Datasets:
 - All the datasets use for the training and testing can be found under the Data directory
 - Original dataset - 11 users 1 training sample per user, 8 users 1 testing sample per user
 - Extended dataset 1 - Original dataset + 1 train and 1 test voice sample from us.
 - Extended dataset 2 - Original dataset + different words (only appear in testset) such as sorry, yes, and why in other languages. 
 ( Japanese, Mandarin )
  - Extended dataset 3 - Original dataset but remove the "pre-emphasis" function block (ablation study).
  - Extended dataset 4 - Original dataset but use notch filters of different width on the voice sample.

## Results:

### Overall performances 
Dataset | Training Acc. | Testing Acc.
--- | --- | --- 
Original| 100% | 100% 
Extended 1| 100% | 100% 
Extended 2| 100% | 92% 
Extended 3| 100% | 92% 

### Example of MFCC vectors in a 2D plane and the resulting VQ codewords (Test 5-6)
![alt text3](https://github.com/SendurLanter/Speaker-Recognition-and-Preprocessing-/blob/main/Figures/4.5.jpg?raw=true)
![alt text3](https://github.com/SendurLanter/Speaker-Recognition-and-Preprocessing-/blob/main/Figures/fig6.jpg?raw=true)

### Results in detail
#### Original training set (TEST 7)
![alt text](https://github.com/SendurLanter/Speaker-Recognition-and-Preprocessing-/blob/main/Figures/1.png?raw=true)
#### Original test set (TEST 7)
![alt text1](https://github.com/SendurLanter/Speaker-Recognition-and-Preprocessing-/blob/main/Figures/2.png?raw=true)
#### Extended 1 test set (TEST 9)
![alt text2](https://github.com/SendurLanter/Speaker-Recognition-and-Preprocessing-/blob/main/Figures/3.png?raw=true)
#### Extended 2 test set
![alt text2](https://github.com/SendurLanter/Speaker-Recognition-and-Preprocessing-/blob/main/Figures/table4.jpg?raw=true)
#### Extended 3 test set (ablation study)
![alt text2](https://github.com/SendurLanter/Speaker-Recognition-and-Preprocessing-/blob/main/Figures/table5.jpg?raw=true)
#### Extended dataset 4: notch filters (TEST 8)
![alt text2](https://github.com/SendurLanter/Speaker-Recognition-and-Preprocessing-/blob/main/Figures/table6.jpg?raw=true)
