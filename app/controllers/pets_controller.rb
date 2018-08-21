class PetsController < ApplicationController

  get '/pets' do
    @pets = Pet.all
    erb :'/pets/index' 
  end

  get '/pets/new' do
    @owners = Owner.all 
    erb :'/pets/new'
  end

  post '/pets' do
    puts params 
    # helper method to create and save pet, called in either "if" case below
    def create_n_save
      @pet = Pet.create({name: params[:pet_name], owner_id: params[:owner_ids][0]})
      @pet.save
      redirect to "pets/#{@pet.id}"
    end

    #actual flow
    if (params[:owner_name].length > 0)
      owner = Owner.new({name: params[:owner_name]})
      owner.save
      params[:owner_ids] = [owner.id]
      create_n_save()
    elsif (params[:owner_ids].length > 0)
      create_n_save()
    else 
      redirect to '/pets/new'
    end
  end

  get '/pets/:id' do 
    @pet = Pet.find(params[:id])
    erb :'/pets/show'
  end

  post '/pets/:id' do 
    redirect to "pets/#{@pet.id}"
  end

  get '/pets/:id/edit' do
    @pet = Pet.find(params[:id])
    @owners = Owner.all
    erb :'/pets/edit'
  end

  post '/pets/:id/edit' do
    puts params
    @pet = Pet.find(params[:id])
    if params[:owner][:name].length > 0
      @owner = Owner.new({name: params[:owner][:name]})
    else
      @owner = Owner.find(params[:owner][:id])
    end

    @pet.update({name: params[:pet_name], owner: @owner})
    erb :'/pets/show'
  end
  
end