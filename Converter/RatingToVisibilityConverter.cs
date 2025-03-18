using System.Windows.Data;

namespace CommitAndForget.Converter
{
  public class RatingToVisibilityConverter : IValueConverter
  {
    public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
    {
      if (value is int rating && Int32.TryParse(parameter.ToString(), out int buttonNumber))
        return rating >= buttonNumber ? System.Windows.Visibility.Visible : System.Windows.Visibility.Collapsed;

      return System.Windows.Visibility.Collapsed;
    }
    public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
    {
      throw new NotImplementedException();
    }
  }
}
