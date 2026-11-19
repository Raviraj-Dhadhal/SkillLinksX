namespace SkillLinksX.Admin
{
    public partial class Students
    {
        protected global::System.Web.UI.WebControls.TextBox txtSearchStudent;
        protected global::System.Web.UI.WebControls.DropDownList ddlGradYear;
        protected global::System.Web.UI.WebControls.DropDownList ddlStatusFilter;
        protected global::System.Web.UI.WebControls.Label lblAdminMessage;
        protected global::System.Web.UI.WebControls.Repeater rptStudents;

        // Modal Controls for Add Student
        protected global::System.Web.UI.WebControls.TextBox txtNewStudentName;
        protected global::System.Web.UI.WebControls.TextBox txtNewStudentEmail;
        protected global::System.Web.UI.WebControls.TextBox txtNewStudentPassword;
        protected global::System.Web.UI.WebControls.TextBox txtNewStudentPhone;
        protected global::System.Web.UI.WebControls.TextBox txtNewStudentCollege;
        protected global::System.Web.UI.WebControls.TextBox txtNewStudentDegree;
        protected global::System.Web.UI.WebControls.DropDownList ddlNewStudentGradYear;
        protected global::System.Web.UI.WebControls.TextBox txtNewStudentSkills;
        protected global::System.Web.UI.WebControls.TextBox txtNewStudentCity;
        protected global::System.Web.UI.WebControls.DropDownList ddlNewStudentState;
        protected global::System.Web.UI.WebControls.DropDownList ddlNewStudentStatus;
        protected global::System.Web.UI.WebControls.Label lblNewStudentError;
        protected global::System.Web.UI.WebControls.Button btnSaveNewStudent;
    }
}
