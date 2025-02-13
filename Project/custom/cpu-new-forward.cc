#include "cpu-new-forward.h"

void conv_forward_cpu(float *output, const float *input, const float *mask, const int B, const int M, const int C, const int H, const int W, const int K, const int S)
{
  /*
    Modify this function to implement the forward pass described in Chapter 16.
    The code in 16 is for a single image.
    We have added an additional dimension to the tensors to support an entire mini-batch
    The goal here is to be correct, not fast (this is the CPU implementation.)

    Function paramters:
    output - output
    input - input
    k - kernel
    B - batch_size (number of images in x)
    M - number of output feature maps
    C - number of input feature maps
    H - input height dimension
    W - input width dimension
    K - kernel height and width (K x K)
    S - stride step length
    */

  const int H_out = (H - K) / S + 1;
  const int W_out = (W - K) / S + 1;

// We have some nice #defs for you below to simplify indexing. Feel free to use them, or create your own.
// An example use of these macros:
// float a = in_4d(0,0,0,0)
// out_4d(0,0,0,0) = a
#define out_4d(i3, i2, i1, i0) output[(i3) * (M * H_out * W_out) + (i2) * (H_out * W_out) + (i1) * (W_out) + i0]
#define in_4d(i3, i2, i1, i0) input[(i3) * (C * H * W) + (i2) * (H * W) + (i1) * (W) + i0]
#define mask_4d(i3, i2, i1, i0) mask[(i3) * (C * K * K) + (i2) * (K * K) + (i1) * (K) + i0]

  // Insert your CPU convolution kernel code here
  // Loop over each image in the batch
  for (int b = 0; b < B; ++b)
  {
    // Loop over each output feature map
    for (int m = 0; m < M; ++m)
    {
      // Loop over height and width of output feature map
      for (int h = 0; h < H_out; ++h)
      {
        for (int w = 0; w < W_out; ++w)
        {
          float sum = 0.0f;
          // Loop over each input feature map
          for (int c = 0; c < C; ++c)
          {
            // Loop over kernel
            for (int p = 0; p < K; ++p)
            {
              for (int q = 0; q < K; ++q)
              {
                int h_in = h * S + p;
                int w_in = w * S + q;
                float val = in_4d(b, c, h_in, w_in);
                float mask_val = mask_4d(m, c, p, q);
                sum += val * mask_val;
              }
            }
          }
          out_4d(b, m, h, w) = sum;
        }
      }
    }
  }

#undef out_4d
#undef in_4d
#undef mask_4d
}