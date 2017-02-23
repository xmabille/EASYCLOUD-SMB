function Register-Classes {
	[CmdletBinding()]
	param()

	Add-Type -typedefinition @"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

    public enum TenantType {
        Office = 0,
        Azure = 1,
        All = 2
    }
  
    public class License
    {
        public string Id;
        public string Name;
        public int Available;

        public override string ToString()
        {
            return Name;
        }

    }

    public class Subscription
    {
        public string Id;
        public string Name;
        public bool Active;

        public override string ToString()
        {
            return Name;
        }
    }

    public class Group : System.IEquatable<Group>
    {

        public string Name;
        public string Description;
        public User Owner;


        public override string ToString()
        {
            return Name;
        }
        public override int GetHashCode()
        {
            return this.Name.GetHashCode();
        }
        public override bool Equals(object obj)

        {
            var other = obj as Group;
            if (other == null) return false;

            return Equals(other);
        }

        public bool Equals(Group other)
        {
            if (other == null)
            {
                return false;
            }
            return System.StringComparer.Ordinal.Equals(Name, other.Name);
        }



    }

    public class Country
    {
        public string Name;
        public string Code;

        public override string ToString()
        {
            return Name;
        }
    }

    public class Region
    {

    }

    public class LicenseList : System.Collections.Generic.List<License>
    {
        public LicenseList():base()
        {
        
        }
        public override string ToString()
        {
            String str = "";

            foreach (License license in this)
            {
                str += license.Name + " ";
            }
            str = str.TrimEnd(' ');
            return str;
        }

    }


    public class User : System.IEquatable<User>
    {
        public string First;
        public string Last;
        public string Title;
        public string DisplayName;
        public string Department;
        public string Office;
        public string Mobile;
        public string Country;
        public System.Collections.Generic.List<Group> Groups;
        public LicenseList Licenses;
        public string Password;
        public string Login;

        public User()
        {
            this.Groups = new System.Collections.Generic.List<Group>();
            this.Licenses = new LicenseList();
        }
        public override string ToString()
        {
            return First + " " + Last;
        }
        public override int GetHashCode()
        {
            return this.DisplayName.GetHashCode();
        }

        public override bool Equals(Object obj)
        {
            var other = obj as User;
            if (other == null) return false;

            return Equals(other);
        }

        public bool Equals(User other)
        {
            if (other == null)
            {
                return false;
            }
            if (ReferenceEquals(this, other))
            {
                return true;
            }

            return System.StringComparer.Ordinal.Equals(this.DisplayName, other.DisplayName);
        }

    }


    public class DeploymentOption
    {
        public string Name;
        public string Description;
        public object Value;

        public DeploymentOption(string Name, string Description, object Value)
        {
            this.Name = Name;
            this.Description = Description;
            this.Value = Value;
        }

    }

    public class Tenant
    {
        public string Id;
        public string Name;
        public bool Default = true;
        public TenantType Type;

        public override string ToString()
        {
            return Name + " (" + Id + ") - " + Type;
        }


    }

    public class TenantInfo
    {
        public string Name;
        public string Address;
        public string Number;
        public string ZIP;
        public string City;
        public string State;
        public string Country;
        public string OPhone;
        public string Fax;

    }

"@ -IgnoreWarnings -ErrorAction SilentlyContinue
}