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

      if (image == MessageBoxImage.Error)
        message = $"Es ist ein Fehler aufgetreten: {message}";

      MessageBox.Show(message, title, MessageBoxButton.OK, image);
    }
    public static MessageBoxResult LogoutMessage(string message, MessageBoxImage image)
    {
      string title = image switch
      {
        MessageBoxImage.Error => "Fehler",
        MessageBoxImage.Warning => "Warnung",
        MessageBoxImage.Information => "Information",
        _ => "Meldung"
      };

      if (image == MessageBoxImage.Error)
        message = $"Es ist ein Fehler aufgetreten: {message}";

      return MessageBox.Show(message, title, MessageBoxButton.YesNo, image);
    }
  }
}
