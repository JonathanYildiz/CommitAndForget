using System.Windows;
using System.Windows.Controls;

namespace CommitAndForget.View.UserViews
{
  public partial class ProductView : Page
  {
    public ProductView()
    {
      InitializeComponent();
    }

    private void DeselectIngredients(object sender, RoutedEventArgs e) => IngredientList.UnselectAll();
  }
}
