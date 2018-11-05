class PetsController < ApplicationController
  def index
    pets = Pet.all

    # render json: pets.as_json( only: [:id, :name, :age, :human]), status: :ok
    render json: jsonify(pets), status: :ok
  end

  def show
    pet_id = params[:id]
    pet = Pet.find_by(id: pet_id)

    if pet
      # render json: pet.as_json(only: [:id, :name, :age, :human]), status :ok
      render json: jsonify(pet), status: :ok
    else
      # head :not_found
      # render json: {}, status: :not_found
      # render json: {errors: {pet_id: ["no such pet"]}}, status: :not_found
      render_error(:not_found, {pet_id: ["no such pet"]})
    end
  end

  def create
    pet = Pet.new(pet_params)
    if pet.save
      render json: {id: pet.id}
    else
      render_error(:bad_request, pet.errors.messages)
    end
  end

  # in postman inside raw do:
  # {
  #   "pet": {
  #     "name": "gecky",
  #     "age": 22,
  #     "human": "dan"
  #   }
  #
  # }

  private

  def pet_params
    params.require(:pet).permit(:name, :age, :human)
  end

  def jsonify(pet_data)
    return pet_data.as_json(only: [:id, :name, :age, :human])
  end
end
