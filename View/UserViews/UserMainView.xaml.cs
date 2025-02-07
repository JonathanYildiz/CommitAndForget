using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using CommitAndForget.View.UserViews;
using CommitAndForget.ViewModel;

namespace CommitAndForget.View
{
  public partial class UserMainView : Window
  {
    public UserMainView()
    {
      InitializeComponent();
    }

    private void Window_Loaded(object sender, RoutedEventArgs e)
    {
      var view = new UserSelectionView();
      view.DataContext = DataContext;
      ((UserViewModel)DataContext).MainFrame = MainFrame; // Mainframe aus XAML in ViewModel durchreichen
      MainFrame.Navigate(view);
    }
  }
}
