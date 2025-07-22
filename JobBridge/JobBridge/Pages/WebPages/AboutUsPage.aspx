<%@ Page Title="About Us" Language="C#" MasterPageFile="~/MasterPages/WebPagesSite.Master" 
    AutoEventWireup="true" CodeBehind="AboutUsPage.aspx.cs" Inherits="JobBridge.Pages.WebPages.AboutUsPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .team-card {
            transition: all 0.3s ease;
        }
        .team-card:hover {
            transform: translateY(-5px);
        }
        .team-photo {
            width: 160px;
            height: 160px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid white;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .milestone-item {
            position: relative;
            padding-left: 2rem;
        }
        .milestone-item::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0.5rem;
            width: 1rem;
            height: 1rem;
            border-radius: 50%;
            background-color: var(--primary);
        }
        .milestone-item:not(:last-child)::after {
            content: '';
            position: absolute;
            left: 0.5rem;
            top: 1.5rem;
            bottom: -1.5rem;
            width: 2px;
            background-color: #e5e7eb;
        }
        .testimonial-card {
            background: white;
            border-radius: 12px;
            position: relative;
        }
        .testimonial-card::before {
            content: "";
            position: absolute;
            top: 1.5rem;
            left: 1.5rem;
            font-size: 60px;
            color: rgba(79, 70, 229, 0.1);
            font-family: serif;
            line-height: 1;
        }
        .value-card {
            transition: all 0.3s ease;
            border: 1px solid #e5e7eb;
        }
        .value-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <section class="bg-primary py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h1 class="text-4xl font-bold mb-6">Our Story</h1>
            <p class="text-xl mb-8 max-w-3xl mx-auto">
                Connecting talent with opportunity through innovative technology and human insight
            </p>
        </div>
    </section>

    <!-- About Section -->
    <section class="py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid md:grid-cols-2 gap-12 items-center">
                <div>
                    <h2 class="text-3xl font-bold text-gray-900 mb-6">Who We Are</h2>
                    <p class="text-gray-600 mb-4">
                        Founded in 2018, JobBridge is a leading talent acquisition platform that uses 
                        artificial intelligence to match qualified candidates with companies looking 
                        for their specific skills and experience.
                    </p>
                    <p class="text-gray-600 mb-4">
                        Our mission is to make hiring and job searching more efficient, transparent, 
                        and human-centered. We believe the right connection can transform careers 
                        and businesses alike.
                    </p>
                    <p class="text-gray-600">
                        Today, we serve thousands of companies and job seekers across North America, 
                        with plans to expand globally in the coming years.
                    </p>
                </div>
                <div class="bg-gray-50 p-8 rounded-xl">
                    <img src="https://www.respectgroupinc.com/wp-content/uploads/2022/11/AdobeStock_306010633-scaled.jpeg" alt="JobBridge team" class="rounded-lg shadow-lg w-full" />
                </div>
            </div>
        </div>
    </section>

    <!-- Values Section -->
    <section class="py-16 bg-gray-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-3xl font-bold text-gray-900 mb-4">Our Core Values</h2>
                <p class="text-xl text-gray-600 max-w-3xl mx-auto">
                    These principles guide everything we do at JobBridge
                </p>
            </div>
            
            <div class="grid md:grid-cols-3 gap-8">
                <div class="value-card bg-white p-8 rounded-xl">
                    <div class="w-14 h-14 bg-blue-100 rounded-lg flex items-center justify-center mb-6">
                        <i class="fas fa-lightbulb text-primary text-2xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold text-gray-900 mb-3">Innovation</h3>
                    <p class="text-gray-600">
                        We constantly push boundaries to create better solutions for candidates and employers.
                    </p>
                </div>
                
                <div class="value-card bg-white p-8 rounded-xl">
                    <div class="w-14 h-14 bg-blue-100 rounded-lg flex items-center justify-center mb-6">
                        <i class="fas fa-handshake text-primary text-2xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold text-gray-900 mb-3">Integrity</h3>
                    <p class="text-gray-600">
                        We're committed to ethical practices and transparency in all our relationships.
                    </p>
                </div>
                
                <div class="value-card bg-white p-8 rounded-xl">
                    <div class="w-14 h-14 bg-blue-100 rounded-lg flex items-center justify-center mb-6">
                        <i class="fas fa-users text-primary text-2xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold text-gray-900 mb-3">People First</h3>
                    <p class="text-gray-600">
                        Behind every data point is a human being - we never lose sight of that.
                    </p>
                </div>
            </div>
        </div>
    </section>
 

    <!-- Milestones Section -->
    <section class="py-16 bg-gray-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-3xl font-bold text-gray-900 mb-4">Our Journey</h2>
                <p class="text-xl text-gray-600 max-w-3xl mx-auto">
                    Key milestones in JobBridge's growth and development
                </p>
            </div>
            
            <div class="max-w-3xl mx-auto">
                <div class="space-y-8">
                    <asp:Repeater ID="rptMilestones" runat="server">
                        <ItemTemplate>
                            <div class="milestone-item">
                                <div class="bg-white p-6 rounded-lg shadow-sm">
                                    <div class="text-primary font-bold mb-1"><%# Eval("Year") %></div>
                                    <h3 class="text-xl font-semibold text-gray-900 mb-2"><%# Eval("Title") %></h3>
                                    <p class="text-gray-600"><%# Eval("Description") %></p>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials Section -->
    <section class="py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-3xl font-bold text-gray-900 mb-4">What Our Community Says</h2>
                <p class="text-xl text-gray-600 max-w-3xl mx-auto">
                    Hear from companies and candidates who have used JobBridge
                </p>
            </div>
            
            <div class="grid md:grid-cols-3 gap-8">
                <asp:Repeater ID="rptTestimonials" runat="server">
                    <ItemTemplate>
                        <div class="testimonial-card p-8">
                            <div class="flex items-center mb-6">
                                <img src='<%# Eval("Photo") %>' 
                                    class="w-12 h-12 object-cover rounded-full mr-4" alt='<%# Eval("Name") %>' />
                                <div>
                                    <h4 class="font-semibold text-gray-900"><%# Eval("Name") %></h4>
                                    <p class="text-gray-600 text-sm"><%# Eval("Role") %> at <%# Eval("Company") %></p>
                                </div>
                            </div>
                            <p class="text-gray-700"><%# Eval("Quote") %></p>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="py-16 bg-primary">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h2 class="text-3xl font-bold mb-6">Ready to Join Our Community?</h2>
            <p class="text-xl mb-8 max-w-3xl mx-auto opacity-90">
                Whether you're looking for talent or opportunities, we're here to help
            </p>
            <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <a href="/Pages/WebPages/Register.aspx?type=employer" 
                    class="btn btn-primary text-white px-8 py-3 rounded-lg text-lg font-semibold">
                    I'm Hiring
                </a>
                <a href="/Pages/WebPages/Register.aspx?type=candidate" 
                    class="btn btn-secondary px-8 py-3 rounded-lg text-lg font-semibold">
                    I'm Job Seeking
                </a>
            </div>
        </div>
    </section>
</asp:Content>