from PIL import Image
import numpy as np
im = Image.open("WinImage.png")
p = np.array(im)
with open('you_win.txt','w') as f:
	for row in range(len(p)):
		for col in range(len(p[0])):
			R = p[row][col][0]
			Rbin = format(R,'050b')
			G = p[row][col][1]
			Gbin = format(G,'060b')
			B = p[row][col][2]
			Bbin = format(B,'050b')
			f.write(Rbin[-8:-3]+'_'+Gbin[-8:-2]+'_'+Bbin[-8:-3]+'\n')