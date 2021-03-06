// Assumes Kernel is 5x5

typedef struct
{
	float r;
	float g;
	float b;
} pixel_t;

__kernel void convolve(
	const __global pixel_t * pad, 
	__global float * kern, 
	__global pixel_t * out, 
	const int pad_num_col,
	const float median_index) 
{ 
	const int NUM_ITERATIONS = 8;

	const int out_num_col = get_global_size(0);
	const int out_col = get_global_id(0); 
	const int out_row = get_global_id(1);

	float buffer[25];
	pixel_t pix;

	int pad_row_head;
	int index = 0;
	int i = 0;

	// copy into buffer
	pad_row_head = out_row * pad_num_col + out_col;
	pix = pad[pad_row_head];   buffer[0] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+1]; buffer[1] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+2]; buffer[2] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+3]; buffer[3] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+4]; buffer[4] = pix.r + pix.g + pix.b;

	pad_row_head += pad_num_col;
	pix = pad[pad_row_head];   buffer[5] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+1]; buffer[6] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+2]; buffer[7] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+3]; buffer[8] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+4]; buffer[9] = pix.r + pix.g + pix.b;

	pad_row_head += pad_num_col;
	pix = pad[pad_row_head];   buffer[10] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+1]; buffer[11] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+2]; buffer[12] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+3]; buffer[13] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+4]; buffer[14] = pix.r + pix.g + pix.b;

	pad_row_head += pad_num_col;
	pix = pad[pad_row_head];   buffer[15] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+1]; buffer[16] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+2]; buffer[17] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+3]; buffer[18] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+4]; buffer[19] = pix.r + pix.g + pix.b;

	pad_row_head += pad_num_col;
	pix = pad[pad_row_head];   buffer[20] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+1]; buffer[21] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+2]; buffer[22] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+3]; buffer[23] = pix.r + pix.g + pix.b;
	pix = pad[pad_row_head+4]; buffer[24] = pix.r + pix.g + pix.b;

	// find median with binary search
	float estimate = 382.5f;
	float lower = 0.0f;
	float upper = 765.0f;
	float higher;

	for (int _ = 0; _ < NUM_ITERATIONS; _++){
		higher = 0;
		higher += ((float)(estimate < buffer[0])) * kern[0];
		higher += ((float)(estimate < buffer[1])) * kern[1];
		higher += ((float)(estimate < buffer[2])) * kern[2];
		higher += ((float)(estimate < buffer[3])) * kern[3];
		higher += ((float)(estimate < buffer[4])) * kern[4];
		higher += ((float)(estimate < buffer[5])) * kern[5];
		higher += ((float)(estimate < buffer[6])) * kern[6];
		higher += ((float)(estimate < buffer[7])) * kern[7];
		higher += ((float)(estimate < buffer[8])) * kern[8];
		higher += ((float)(estimate < buffer[9])) * kern[9];
		higher += ((float)(estimate < buffer[10])) * kern[10];
		higher += ((float)(estimate < buffer[11])) * kern[11];
		higher += ((float)(estimate < buffer[12])) * kern[12];
		higher += ((float)(estimate < buffer[13])) * kern[13];
		higher += ((float)(estimate < buffer[14])) * kern[14];
		higher += ((float)(estimate < buffer[15])) * kern[15];
		higher += ((float)(estimate < buffer[16])) * kern[16];
		higher += ((float)(estimate < buffer[17])) * kern[17];
		higher += ((float)(estimate < buffer[18])) * kern[18];
		higher += ((float)(estimate < buffer[19])) * kern[19];
		higher += ((float)(estimate < buffer[20])) * kern[20];
		higher += ((float)(estimate < buffer[21])) * kern[21];
		higher += ((float)(estimate < buffer[22])) * kern[22];
		higher += ((float)(estimate < buffer[23])) * kern[23];
		higher += ((float)(estimate < buffer[24])) * kern[24];
		if (higher > median_index){
			lower = estimate;
		} else {
			upper = estimate;
		}
		estimate = 0.5 * (upper + lower);
	}

	float diff;
	for (int i=0; i<25; i++){
		diff = (buffer[i] - estimate)/3;
		diff = diff * diff;
		if (diff <= 1){
			out[out_row*out_num_col+out_col] = pad[(i/5+out_row)*pad_num_col+i%5+out_col];
			return;
		}
	}

	pix.r = 255; pix.g = 0; pix.b = 0;
	out[out_row*out_num_col+out_col] = pix;
	return;
} 













