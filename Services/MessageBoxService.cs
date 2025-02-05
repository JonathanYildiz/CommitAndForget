using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace CommitAndForget.Services
{
  public static class MessageBoxService
  {
    public static void DisplayMessage(string message, MessageBoxImage image)
    {
      string title = image switch
      {
        MessageBoxImage.Error => "Fehler",
        MessageBoxImage.Warning => "Warnung",
        MessageBoxImage.Information => "Information",
        _ => "Meldung"
      };

      if(image  == MessageBoxImage.Error)
        message = $"Es ist ein Fehler aufgetreten: {message}";

      MessageBox.Show(message, title, MessageBoxButton.OK, image);
    }
  }
}
