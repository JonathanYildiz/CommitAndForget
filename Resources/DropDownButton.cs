using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;

namespace CommitAndForget.Resources
{
  public class DropDownButton : ToggleButton
  {
    public static readonly DependencyProperty DropDownProperty = DependencyProperty.Register("DropDown", typeof(ContextMenu), typeof(DropDownButton), new UIPropertyMetadata(null));

    public DropDownButton()
    {
      // Binding der ToogleButton.IsChecked-Eigenschaft an die IsOpen-Eigenschaft des Dropdowns

      Binding binding = new Binding("DropDown.IsOpen");
      binding.Source = this;
      this.SetBinding(IsCheckedProperty, binding);
    }

    public ContextMenu DropDown
    {
      get => (ContextMenu)GetValue(DropDownProperty);
      set => SetValue(DropDownProperty, value);
    }

    protected override void OnClick()
    {
      if (DropDown != null)
      {
        // Wenn ein Dropdown-Menü zugewiesen ist, dann positioniere und zeige es an

        DropDown.PlacementTarget = this;
        DropDown.Placement = PlacementMode.Bottom;

        DropDown.IsOpen = true;
      }
    }
  }
}
