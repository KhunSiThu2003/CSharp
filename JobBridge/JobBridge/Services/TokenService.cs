using System;
using System.Web;

namespace JobBridge.Services
{
    public static class TokenService
    {
        public static string GetUserRoleFromToken(string token)
        {
            // In a real application, you would:
            // 1. Validate the token
            // 2. Decode it to get claims
            // 3. Extract the role claim

            // For this example, we'll simulate this with a simple check
            // In production, use JWT or your authentication framework

            try
            {
                // This is just a placeholder - replace with actual token validation
                if (token.StartsWith("admin_"))
                    return "Admin";
                if (token.StartsWith("employer_"))
                    return "Employer";
                if (token.StartsWith("jobseeker_"))
                    return "JobSeeker";

                return null;
            }
            catch
            {
                return null;
            }
        }

        public static bool IsTokenValid(string token)
        {
            // Add your token validation logic here
            return !string.IsNullOrEmpty(token);
        }
    }
}