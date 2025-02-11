using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
  }
}
