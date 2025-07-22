<%@ Page Title="Home" Language="C#" MasterPageFile="~/MasterPages/WebPagesSite.Master" 
    AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="JobBridge.Pages.WebPages.HomePage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        
        .hero-pattern {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZyBvcGFjaXR5PSIwLjEiPjxwYXRoIGQ9Ik0wIDIwQzAgOC45NSA4Ljk1IDAgMjAgMEMzMS4wNSAwIDQwIDguOTUgNDAgMjBDNDAgMzEuMDUgMzEuMDUgNDAgMjAgNDBDOC45NSA0MCAwIDMxLjA1IDAgMjBaIiBmaWxsPSIjNEY0NkU1Ii8+PC9nPjwvc3ZnPg==');
            opacity: 0.1;
            z-index: 0;
        }
        
        .feature-card {
            transition: all 0.3s ease;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e5e7eb;
        }
        
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        
        .testimonial-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            position: relative;
            border: 1px solid #e5e7eb;
        }
        
        .testimonial-card:before {
            content: "";
            position: absolute;
            top: 20px;
            left: 20px;
            font-size: 60px;
            color: rgba(79, 70, 229, 0.1);
            font-family: serif;
            line-height: 1;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <section class="hero-section py-16 md:py-24">
        <div class="hero-pattern"></div>
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
            <div class="grid md:grid-cols-2 gap-12 items-center">
                <div class="text-center md:text-left">
                    <h1 class="text-4xl md:text-5xl lg:text-6xl font-bold text-gray-900 mb-6 leading-tight">
                        Build Your <span class="text-primary">Dream Team</span> Faster
                    </h1>
                    <p class="text-xl text-gray-600 mb-8 max-w-lg mx-auto md:mx-0">
                        The intelligent hiring platform that connects employers with top talent and helps job seekers find their perfect career match.
                    </p>
                    <div class="flex flex-col sm:flex-row gap-4 justify-center md:justify-start">
                        <asp:Button ID="btnGetStart" runat="server" Text="Get Start" 
                            CssClass="btn btn-primary text-white px-8 py-3 rounded-lg text-lg font-semibold" />
                    </div>

                    <div class="mt-12 flex flex-wrap items-center justify-center md:justify-start gap-6">
                        <div class="flex items-center gap-2">
                            <div class="flex -space-x-2">
                                <img src="https://play-lh.googleusercontent.com/rPq4GMCZy12WhwTlanEu7RzxihYCgYevQHVHLNha1VcY5SU1uLKHMd060b4VEV1r-OQ" class="w-10 h-10 rounded-full border-2 border-white" alt="User">
                                <img src="https://static.vecteezy.com/system/resources/thumbnails/007/620/961/small_2x/letter-logo-m-with-modern-abstract-style-part-3-vector.jpg" class="w-10 h-10 rounded-full border-2 border-white" alt="User">
                                <img src="https://images-platform.99static.com//eAp_8c9kCWP4Q-rX_Xs8CPgkeCM=/19x15:979x975/fit-in/500x500/99designs-contests-attachments/67/67180/attachment_67180554" class="w-10 h-10 rounded-full border-2 border-white" alt="User">
                            </div>
                            <div class="text-left">
                                <div class="text-sm font-medium text-gray-700">5,000+ Companies</div>
                                <div class="text-xs text-gray-500">Trust our platform</div>
                            </div>
                        </div>
                        <div class="flex items-center gap-2">
                            <div class="flex items-center">
                                <svg class="w-5 h-5 text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                                </svg>
                                <span class="ml-1 text-gray-700 font-medium">4.9/5</span>
                            </div>
                            <div class="text-left">
                                <div class="text-sm font-medium text-gray-700">2,500+ Reviews</div>
                                <div class="text-xs text-gray-500">From our users</div>
                            </div>
                        </div>
                    </div>

                </div>
                <div class="relative hidden md:block">
                    <div class="relative z-10">
                        <img src="https://cssanimation.io/blog/wp-content/uploads/2023/09/Teamwork-And-Collaboration-How-To-Improve-Both-At-Work-1.jpg" alt="Team working together" class="rounded-xl shadow-xl border border-gray-100 w-full max-w-lg mx-auto" />
                    </div>
                    <div class="absolute -bottom-6 -left-6 w-24 h-24 bg-blue-200 rounded-lg shadow-lg floating-delay hidden lg:block"></div>
                    <div class="absolute -top-6 -right-6 w-20 h-20 bg-blue-100 rounded-full shadow-lg floating-delay hidden lg:block"></div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="py-16 bg-gray-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-3xl font-bold text-gray-900 mb-4">Why Choose JobBridge?</h2>
                <p class="text-lg text-gray-600 max-w-3xl mx-auto">Our platform is designed to make hiring and job searching effortless and efficient.</p>
            </div>
            
            <div class="grid md:grid-cols-3 gap-8">
                <div class="feature-card p-8">
                    <div class="w-14 h-14 bg-blue-100 rounded-lg flex items-center justify-center mb-6">
                        <svg class="w-6 h-6 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                        </svg>
                    </div>
                    <h3 class="text-xl font-semibold text-gray-900 mb-3">Smart Matching</h3>
                    <p class="text-gray-600">Our AI-powered algorithm matches the right candidates with the right jobs based on skills and preferences.</p>
                </div>
                
                <div class="feature-card p-8">
                    <div class="w-14 h-14 bg-blue-100 rounded-lg flex items-center justify-center mb-6">
                        <svg class="w-6 h-6 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>
                        </svg>
                    </div>
                    <h3 class="text-xl font-semibold text-gray-900 mb-3">Verified Profiles</h3>
                    <p class="text-gray-600">All candidates and companies are thoroughly vetted to ensure quality and authenticity.</p>
                </div>
                
                <div class="feature-card p-8">
                    <div class="w-14 h-14 bg-blue-100 rounded-lg flex items-center justify-center mb-6">
                        <svg class="w-6 h-6 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                    </div>
                    <h3 class="text-xl font-semibold text-gray-900 mb-3">Easy Scheduling</h3>
                    <p class="text-gray-600">Integrated calendar tools make scheduling interviews simple and hassle-free.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials Section -->
    <section class="py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-3xl font-bold text-gray-900 mb-4">What Our Users Say</h2>
                <p class="text-lg text-gray-600 max-w-3xl mx-auto">Don't just take our word for it - hear from our satisfied customers.</p>
            </div>
            
            <div class="grid md:grid-cols-3 gap-8">
                <div class="testimonial-card p-8">
                    <div class="flex items-center mb-6">
                        <img src="https://www.shutterstock.com/image-photo/close-head-shot-portrait-preppy-600nw-1433809418.jpg" class="w-12 h-12 object-cover rounded-full mr-4" alt="Sarah Johnson">
                        <div>
                            <h4 class="font-semibold text-gray-900">Sarah Johnson</h4>
                            <p class="text-gray-600 text-sm">HR Manager, TechCorp</p>
                        </div>
                    </div>
                    <p class="text-gray-700">"JobBridge helped us find three perfect candidates in just two weeks. The matching algorithm is incredibly accurate!"</p>
                </div>
                
                <div class="testimonial-card p-8">
                    <div class="flex items-center mb-6">
                        <img src="https://t3.ftcdn.net/jpg/06/39/64/14/360_F_639641415_lLjzVDVwL0RwdNrkURYFboc4N21YIXJR.jpg" class="w-12 h-12 object-cover rounded-full mr-4" alt="Michael Chen">
                        <div>
                            <h4 class="font-semibold text-gray-900">Michael Chen</h4>
                            <p class="text-gray-600 text-sm">Software Developer</p>
                        </div>
                    </div>
                    <p class="text-gray-700">"I found my dream job through JobBridge. The platform made the entire process so smooth and stress-free."</p>
                </div>
                
                <div class="testimonial-card p-8">
                    <div class="flex items-center mb-6">
                        <img src="https://sb.kaleidousercontent.com/67418/1920x1545/c5f15ac173/samuel-raita-ridxdghg7pw-unsplash.jpg" class="w-12 h-12 object-cover rounded-full mr-4" alt="Emily Rodriguez">
                        <div>
                            <h4 class="font-semibold text-gray-900">Emily Rodriguez</h4>
                            <p class="text-gray-600 text-sm">CEO, DesignStudio</p>
                        </div>
                    </div>
                    <p class="text-gray-700">"The quality of candidates we've found through JobBridge is unmatched. It's become our go-to hiring platform."</p>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="py-16 bg-primary">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h2 class="text-3xl font-bold mb-6">Ready to Transform Your Hiring Process?</h2>
            <p class="text-xl mb-8 max-w-3xl mx-auto opacity-90">Join thousands of companies who have found their perfect hires through JobBridge.</p>
            <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <asp:Button ID="btnCtaPostJob" runat="server" Text="Post a Job for Free" 
                    OnClick="btnPostJob_Click"
                    CssClass="btn btn-primary px-5 py-2 rounded-lg text-white" />
                <asp:Button ID="btnCtaContact" runat="server" Text="Contact Sales" 
                    CssClass="btn btn-secondary px-5 py-2 rounded-lg" />
            </div>
        </div>
    </section>
</asp:Content>