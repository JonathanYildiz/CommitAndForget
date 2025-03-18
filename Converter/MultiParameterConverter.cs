using CommitAndForget.Model;
using System.Windows.Data;

namespace CommitAndForget.Converter
{
  public class MultiParameterConverter : IMultiValueConverter
  {
    public object Convert(object[] values, Type targetType, object parameter, System.Globalization.CultureInfo culture)
    {
      return new Tuple<ImageModel, int>((ImageModel)values[0], (int)values[1]);
    }

    public object[] ConvertBack(object value, Type[] targetTypes, object parameter, System.Globalization.CultureInfo culture)
    {
      throw new NotImplementedException();
    }
  }
}
