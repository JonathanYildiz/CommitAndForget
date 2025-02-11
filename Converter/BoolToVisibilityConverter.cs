using System.Globalization;
using System.Windows;
using System.Windows.Data;

namespace CommitAndForget.Converter
{
  public class BoolToVisibilityConverter : IValueConverter
  {
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
    {
      if (value is bool boolValue)
      {
        bool invert = parameter != null && bool.TryParse(parameter.ToString(), out bool invertParam) && invertParam;
        if (invert)
        {
          boolValue = !boolValue;
        }
        return boolValue ? Visibility.Visible : Visibility.Collapsed;
      }
      return Visibility.Collapsed;
    }

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
    {
      if (value is Visibility visibility)
      {
        bool result = visibility == Visibility.Visible;
        bool invert = parameter != null && bool.TryParse(parameter.ToString(), out bool invertParam) && invertParam;
        if (invert)
        {
          result = !result;
        }
        return result;
      }
      return false;
    }
  }
}
