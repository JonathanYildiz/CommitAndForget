using System;
using System.IO;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace CommitAndForget.Converter
{
  public static class ByteArrayToBitmapImageConverter
  {
    public static BitmapImage LoadImage(byte[] imageData)
    {
      using (var ms = new MemoryStream(imageData))
      {
        var image = new BitmapImage();
        image.BeginInit();
        image.CacheOption = BitmapCacheOption.OnLoad;
        image.StreamSource = ms;
        image.EndInit();
        image.Freeze(); // Optional: um das Bild thread-sicher zu machen  
        return image;
      }
    }

    public static byte[] SaveImage(ImageSource imageSource)
    {
      if (imageSource is BitmapSource bitmapSource)
      {
        byte[] imageData;
        BitmapEncoder encoder = new JpegBitmapEncoder();
        encoder.Frames.Add(BitmapFrame.Create(bitmapSource));
        using (MemoryStream ms = new MemoryStream())
        {
          encoder.Save(ms);
          imageData = ms.ToArray();
        }
        return imageData;
      }
      throw new ArgumentException("imageSource must be of type BitmapSource", nameof(imageSource));
    }
  }
}