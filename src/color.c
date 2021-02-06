int mmap(x, y) {
	// The Gameboy has a 15bit 240x160 pixel colour LCD screen
	// VRAM starts from 0x600_0000 - 0x601_7FFF (96kb)
	// Need to map x,y position to global VRAM position in memory
	return (x + y*240);
}


int rgb(r, g, b) {
	// VRAM is RGB and 15bits, so first 5bits R, next 5bits G, last 5 bits B
	// Red   = 000000000011111 (0x001F)
	// Green = 000001111100000 (0x03E0)
	// Blue  = 111110000000000 (0x7C00)
	r = r & 0x1F; // Clamp the values to 5 bits
	g = g & 0x1F;
	b = b & 0x1F;
	return (r | (g << 5) | (b << 10));
}


int main(void) {
	// Write into the I/O registers, setting video display parameters.
	volatile unsigned char *ioram = (unsigned char *)0x04000000;
	ioram[0] = 0x03; // Use video mode 3 (in BG2, a 16bpp bitmap in VRAM)
	ioram[1] = 0x04; // Enable BG2 (BG0 = 1, BG1 = 2, BG2 = 4, ...)

	// Initialize variables
	int t = 0; // counter variable
	int x, y; // x,y co-ordiantes of display (240 x 160) pixels
	int r, g, b; // store the rgb values of a pixel

	// Define the start VRAM
	volatile unsigned short *vram = (unsigned short *)0x06000000;

	// Slow loop
	while(1) {
		// Loop through all columns of the display
		for (x = 0; x < 240; x++) {
			// Loop through all roms of the display
			for (y = 0; y < 160; y++) {
				r = (x&y) + t*5;
				g = (x&y) + t*3;
				b = (x&y) + t;

				vram[mmap(x,y)] = rgb(r, g, b);

				//vram[x + y*240] = ((((x&y)+t) & 0x1F) << 10) | ((((x&y)+t*3)&0x1F)<<5) | ((((x&y)+t * 5)&0x1F)<<0);
			}
		}
		t++;
	}
	return 0;
}