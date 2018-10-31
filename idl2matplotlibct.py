# for calculating colormap from an idl colourtable

import matplotlib.pyplot as plt
from matplotlib import colors
import numpy as np

def make_colourmap(ind, red, green, blue, name):
	newInd = range(0, 256)
	r = np.interp(newInd, ind, red, left=None, right=None)
	g = np.interp(newInd, ind, green, left=None, right=None)
	b = np.interp(newInd, ind, blue, left=None, right=None)
	colours = np.transpose(np.asarray((r, g, b)))
	fctab= colours/255.0
	cmap = colors.ListedColormap(fctab, name=name,N=None) 
	return cmap