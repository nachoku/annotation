class MainController < ApplicationController

respond_to :html

  def front
    if params[:query]
        @images= RubyWebSearch::Google.search(:query => params[:query], :size => params[:size].to_i )    
        @search1= Search.new(:query => params[:query], :link_num => params[:size].to_i)
        @search1.save      
        @images.results.to_a.each do |image| 
           @page = MetaInspector.new(image[:url], faraday_options: { ssl: { verify: false } })
            begin
            @url1= Url.new(:search_id => @search1.id, :link => (image[:url]), :web => Sanitize.clean(@page.to_s.force_encoding 'UTF-8'))
            @url1.save 
            rescue
              @url1= Url.new(:search_id => @search1.id, :link => (image[:url]), :web => @page)
            @url1.save 
            end
           if @page.meta['keywords'].nil?
           else
            @words = @page.meta['keywords'].split(',') 
            @words.to_a.each do |word|
              @keyword1= Keyword.new(:search_id => @search1.id, :word => word) 
              @keyword1.save
            end
           end    
          


             begin

             @page1=@url1.web
             text = Highscore::Content.new  @page1
             text.configure do
              set :multiplier, 2
              set :upper_case, 3
              set :long_words, 2
              set :long_words_threshold, 15
              set :short_words_threshold, 3      # => default: 2
              set :bonus_multiplier, 2           # => default: 3
              set :vowels, 1                     # => default: 0 = not considered
              set :consonants, 5                 # => default: 0 = not considered
              set :ignore_case, true             # => default: false
              set :word_pattern, /[a-z]*/ # => default: /\w+/
              set :stemming, false                # => default: false
            end 
              text.keywords.top(50).each do |keyword| 
                @keyword1= Keyword.new(:search_id => @search1.id, :word => keyword) 
                @keyword1.save
              end 
             rescue
             
           end

        end  
    else
        @images= RubyWebSearch::Google.search(:query => 'hello', :size => '1'.to_i)
    end
  end


  def sites
    if params[:key]
      @keyword1= Keyword.new(:search_id => params[:link], :word => params[:key]) 
      @keyword1.save
    else

    end
      @page = MetaInspector.new(params[:link], faraday_options: { ssl: { verify: false } })
      if @page.meta['keywords'].nil?
        @temp= params[:link]
      else
      @words = @page.meta['keywords'].split(',')
    end
    rescue

      redirect_to root_path
  
  end

  def implement
    @images= Search.all.order('created_at DESC')
    @urls= Url.all
    if params[:word]

    @url1= Url.new(:search_id => params[:image], :link => 'custom')
    @url1.save
    @keyword1= Keyword.new(:url_id =>  00, :word => params[:word])
    @keyword1.save
    flash[:notice] = "Successfully Added Keyword"
  end
    
  end

  def delete
        begin
        word_id = Keyword.find(params[:id])
        word_id.destroy
      rescue
        redirect_to main_implement_path
      end
  end






  def cluster 
    @temp=Url.where(:search_id => params[:params1].to_i)#get urls
    @t1=Search.find(params[:params1].to_i)

    if params[:params2] 
   #   begin
        @temp.each do |h|
          @list = @list.to_a.push h.id
        end
        @save=params[:params1].to_i
        @t=Keyword.where(:search_id => params[:params1]) #keywords
        @c=params[:params2].to_i
        while @c>0
          @high=0
          @list.each do |list1|
            temp1=Url.find(list1)
            @text1=temp1.web
            @list.each do |list2|
              @counter1=0
              if list1==list2
              else
                temp2=Url.find(list2)
                @text2=temp2.web
                @t.each do |temp1_key|
                  if @text1.include?(temp1_key.word) && @text2.include?(temp1_key.word)
                    @counter1 = @counter1 + 1
                  end
                end            
                if @counter1 > @high
                  @high=@counter1
                  @temper1= temp1.link
                  @temper11= temp1.id
                  @temper2= temp2.link
                  @temper22=temp2.id
                end
              end
            end
          end
          @list=@list-[@temper11 ,@temper22]
            
          @key= Kmean.new(:search_id => @save, :cluster_id =>  @c, :link => @temper1, :url_id => @temper11, :count => @high)
          @key.save
          @key= Kmean.new(:search_id => @save, :cluster_id =>  @c, :link => @temper2, :url_id => @temper22, :count => @high)
          @key.save
          @c=@c-1          

        force_encoding
        vi=Kmean.find_by(:cluster_id => params[:params2].to_i)
        @sa=vi.count

        @kmean=Kmean.where(:search_id => @save)
        @list.each do |list|
        @high=0
          temp=Url.find(list)
          @text1=temp.web
          flag=0
          @kmean.each do |kmean|
            if flag==0
              flag=1             
              @hi=Url.find(kmean.url_id)
              @text2=@hi.web
            else
              flag=0
              @counter1=0
              @hi=Url.find(kmean.url_id)
              @text3=@hi.web
              @t.each do |temp1_key|                    
                if @text1.include?(temp1_key.word) && @text2.include?(temp1_key.word) && @text3.include?(temp1_key.word)
                  @counter1=@counter1+1
                end
              end
              if @counter1 > @high
                @high=@counter1
                @temper1=kmean.cluster_id
                @ll=temp.link
              end 
            end       
          end
          if @high>0
            @key= Kmeean.new(:search_id => @save, :cluster_id => @temper1 , :link => @ll, :count => @high)
            @key.save  
          else
            @key= Kmeean.new(:search_id => @save, :cluster_id => '0'.to_i , :link => list.link, :count => 0)
            @key.save
          end   
        end    

        @ku=Kmean.all
        @ku.each do |x|
          @key= Kmeean.new(:search_id => x.search_id, :cluster_id => x.cluster_id , :link => x.link, :count =>x.count)
          @key.save 
          x.delete
        end


      #rescue
      end
    end



  end

end
