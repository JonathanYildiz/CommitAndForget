using System.Windows;
using System.Windows.Controls;

namespace CommitAndForget.View.UserViews
{
  public partial class MenuView : Page
  {
    public MenuView()
    {
      InitializeComponent();
    }

    private void DeselectIngredients(object sender, RoutedEventArgs e) => IngredientList.UnselectAll();
  }
}
